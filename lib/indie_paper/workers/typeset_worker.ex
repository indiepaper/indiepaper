defmodule IndiePaper.Workers.TypesetWorker do
  use Oban.Worker, queue: :typeset

  alias IndiePaper.Books
  alias IndiePaper.TypesettingEngine

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => book_id}}) do
    book = Books.get_book!(book_id)
    latex = TypesettingEngine.to_latex!(book)

    tmp_dir = System.tmp_dir!()
    File.mkdir_p!(Path.join(tmp_dir, "#{book.id}"))

    tmp_file = Path.join(tmp_dir, "/#{book.id}/book.tex")
    IO.inspect(tmp_file)
    File.write!(tmp_file, latex)
    :ok
  end
end
