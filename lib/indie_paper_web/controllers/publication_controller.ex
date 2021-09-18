defmodule IndiePaperWeb.PublicationController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{Books, Publication}

  def create(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:draft)

    case Publication.publish_book(book) do
      {:ok, book} ->
        redirect(conn, to: Routes.book_path(conn, :show, book))
    end
  end
end
