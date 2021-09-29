defmodule IndiePaperWeb.PublicationController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{Books, Publication}

  def create(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:draft)

    case Publication.publish_book(book) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "#{book.title} has been published. Share it with your readers.")
        |> redirect(to: Routes.book_path(conn, :show, book))
    end
  end
end
