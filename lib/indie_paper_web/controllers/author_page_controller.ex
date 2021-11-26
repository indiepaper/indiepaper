defmodule IndiePaperWeb.AuthorPageController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Authors
  alias IndiePaper.Books

  def show(conn, %{"username" => username}) do
    case Authors.get_author_by_username(username) do
      nil ->
        conn |> put_status(404) |> halt()

      author ->
        published_books = Books.get_published_books(author)

        render(conn, "show.html", author: author, books: published_books)
    end
  end
end
