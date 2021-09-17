defmodule IndiePaperWeb.PublicationController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Books

  def create(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id)

    if Books.is_listing_complete?(book) do
    else
      conn
      |> redirect(to: Routes.book_path(conn, :edit, book))
    end
  end
end
