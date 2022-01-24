defmodule IndiePaperWeb.PublicationControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  alias IndiePaper.Books

  describe "create/2" do
    test "publishes book", %{conn: conn} do
      author = insert(:author)
      book = insert(:book, author: author, status: :pending_publication)
      conn = log_in_author(conn, author)

      post(conn, Routes.book_publication_path(conn, :create, book))

      published_book = Books.get_book!(book.id)
      assert Books.publication_in_progress?(published_book)
    end
  end
end
