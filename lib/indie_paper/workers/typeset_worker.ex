defmodule IndiePaper.Workers.TypesetWorker do
  use Oban.Worker, queue: :typeset

  alias IndiePaper.Books
  alias IndiePaper.Assets
  alias IndiePaper.TypesettingEngine

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => book_id}}) do
    book = Books.get_book!(book_id)

    latex_file_dir =
      TypesettingEngine.to_latex!(book)
      |> write_latex_file!(book.id)

    Path.join(:code.priv_dir(:indie_paper), "/typeset/latex/createspace")
    |> File.cp_r!(latex_file_dir)

    System.cmd("latexmk", ["book.tex", "-pdf"], cd: latex_file_dir, into: "")

    {:ok, published_book} = Books.publish_book(book)
    pdf_asset = Assets.create_or_get_pdf_asset(published_book)

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
