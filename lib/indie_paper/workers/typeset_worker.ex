defmodule IndiePaper.Workers.TypesetWorker do
  use Oban.Worker, queue: :typeset

  alias IndiePaper.Books
  alias IndiePaper.TypesettingEngine

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => book_id}}) do
    book = Books.get_book!(book_id)

    latex = TypesettingEngine.to_latex!(book)
    latex_file_dir = write_latex_file!(book.id, latex)

    createspace_path = Path.join(:code.priv_dir(:indie_paper), "/typeset/latex/createspace")
    File.cp_r!(createspace_path, latex_file_dir)

    System.cmd("latexmk", ["book.tex", "-pdf"],
      cd: latex_file_dir,
      stderr_to_stdout: true
    )

    :ok
  end

  def write_latex_file!(dirname, content) do
    tmp_dir = Path.join(System.tmp_dir!(), dirname)
    File.mkdir_p!(tmp_dir)

    tmp_file = Path.join(tmp_dir, "/book.tex")
    File.write!(tmp_file, content)

    tmp_dir
  end
end
