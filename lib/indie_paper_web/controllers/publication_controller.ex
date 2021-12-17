defmodule IndiePaperWeb.PublicationController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Books
  alias IndiePaper.BookPublisher

  def create(conn, %{"book_slug" => book_slug}) do
    book = Books.get_book_from_slug!(book_slug) |> Books.with_assoc(:draft)

    case BookPublisher.publish_book(book) do
      {:ok, book} ->
        conn
        |> put_flash(
          :info,
          "#{book.title} has been published. Share it with your readers and we'll take care of the rest."
        )
        |> redirect(to: Routes.book_show_path(conn, :show, book))
    end
  end
end
