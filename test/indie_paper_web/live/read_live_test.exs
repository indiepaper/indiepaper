defmodule IndiePaperWeb.ReadLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "show the title of the book", %{conn: conn} do
    reader = insert(:author)
    book = insert(:book)
    conn = log_in_author(conn, reader)
    {:ok, _view, html} = live(conn, Routes.book_read_path(conn, :index, book))

    assert html =~ book.title
  end
end
