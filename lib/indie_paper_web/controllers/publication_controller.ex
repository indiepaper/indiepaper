defmodule IndiePaperWeb.PublicationController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Books
  alias IndiePaper.BookPublisher

  def create(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:draft)

    case BookPublisher.publish_book(book) do
      {:ok, book} ->
        conn
        |> put_flash(
          :info,
          "#{book.title} has been published. Share it with your readers and we'll take care of the rest."
        )
        |> redirect(to: Routes.book_path(conn, :show, book))
    end
  end
end
