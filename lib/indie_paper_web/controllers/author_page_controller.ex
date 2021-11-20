defmodule IndiePaperWeb.AuthorPageController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Authors
  alias IndiePaper.Books

  def show(conn, %{"id" => author_id}) do
    author = Authors.get_author!(author_id)
    published_books = Books.get_published_books(author)

    render(conn, "show.html", author: author, books: published_books)
  end
end
