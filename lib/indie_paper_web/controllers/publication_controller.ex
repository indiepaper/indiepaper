defmodule IndiePaperWeb.PublicationController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{Books, Publication}

  def create(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:draft)

    if Books.is_listing_complete?(book) do
      case Publication.publish_book(book) do
        {:ok, book} ->
          redirect(conn, to: Routes.book_path(conn, :show, book))

        {:error, message} ->
          conn
          |> put_flash(:error, message)
          |> redirect(to: Routes.draft_path(conn, :edit, book.draft))
      end
    else
      conn
      |> redirect(to: Routes.book_path(conn, :edit, book))
    end
  end
end
