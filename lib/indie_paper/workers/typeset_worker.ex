defmodule IndiePaper.Workers.TypesetWorker do
  use Oban.Worker, queue: :typeset

  alias IndiePaper.Books
  alias IndiePaper.Assets
  alias IndiePaper.TypesettingEngine
  alias IndiePaper.ExternalAssetHandler

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => book_id}}) do
    book = Books.get_book!(book_id)

    IO.inspect("JOB START")

    latex_file_dir =
      TypesettingEngine.to_latex!(book)
      |> write_latex_file!(book.id)

    IO.inspect(latex_file_dir)

    Path.join(:code.priv_dir(:indie_paper), "/typeset/latex/createspace")
    |> File.cp_r!(latex_file_dir)

    System.cmd("latexmk", ["book.tex", "-pdf"], cd: latex_file_dir)

    {:ok, published_book} = Books.publish_book(book)
    pdf_asset = Assets.create_or_get_pdf_asset!(published_book)

    pdf_file = File.read!(Path.join(latex_file_dir, "book.pdf"))

    {:ok, _} = ExternalAssetHandler.upload_file(pdf_asset.url, pdf_file, "application/pdf")

    IO.inspect("JOB COMPLETED")
    :ok
  end

  def write_latex_file!(content, dirname) do
    tmp_dir = Path.join(System.tmp_dir!(), dirname)
    File.mkdir_p!(tmp_dir)

    tmp_file = Path.join(tmp_dir, "/book.tex")
    File.write!(tmp_file, content)

    tmp_dir
  end
end
