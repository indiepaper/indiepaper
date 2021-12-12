defmodule IndiePaperWeb.BookController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Books

  action_fallback IndiePaperWeb.FallbackController

  def show(conn, %{"id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc([:author, :draft])
    render(conn, "show.html", book: book)
  end
end
