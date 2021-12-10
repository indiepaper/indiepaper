defmodule IndiePaperWeb.BookPublishChapterLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "show free membership tier on page", %{conn: conn} do
    author = insert(:author)
    book = insert(:book)
    draft = insert(:draft, book: book)
    chapter = insert(:chapter, draft: draft)
    conn = log_in_author(conn, author)
    {:ok, _view, html} = live(conn, Routes.book_publish_chapter_path(conn, :new, book, chapter))

    assert html =~ "Free"
  end
end
