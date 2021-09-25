defmodule IndiePaperWeb.ReadController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Books

  def index(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(draft: :chapters)
    render(conn, "index.html", book: book)
  end
end
