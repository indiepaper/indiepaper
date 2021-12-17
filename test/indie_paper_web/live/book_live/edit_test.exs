defmodule IndiePaperWeb.BookLive.EditTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "author can update listing of book", %{conn: conn} do
    author = insert(:author)
    book = insert(:book, author: author)
    conn = log_in_author(conn, author)

    {:ok, _view, html} = live(conn, Routes.book_edit_path(conn, :edit, book))

    assert html =~ book.title
  end
end
