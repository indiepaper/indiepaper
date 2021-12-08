defmodule IndiePaperWeb.ReadLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias IndiePaper.Chapters

  test "show the title of the book", %{conn: conn} do
    reader = insert(:author)
    book = insert(:book)
    conn = log_in_author(conn, reader)
    {:ok, _view, html} = live(conn, Routes.book_read_path(conn, :index, book))

    assert html =~ book.title
  end

  test "show published chapters of book", %{conn: conn} do
    reader = insert(:author)
    chapter1 = insert(:chapter, published_content_json: nil)
    chapter2 = insert(:chapter, published_content_json: nil)

    book =
      insert(:book, publishing_type: :serial, draft: build(:draft, chapters: [chapter1, chapter2]))

    conn = log_in_author(conn, reader)
    {:ok, _published_chapter} = Chapters.publish_free_serial_chapter(chapter1)
    {:ok, _view, html} = live(conn, Routes.book_read_path(conn, :index, book))

    assert html =~ chapter1.title
    refute html =~ chapter2.title
  end

  test "reader can remove from library", %{conn: conn} do
    reader = insert(:author)
    book = insert(:book, publishing_type: :serial)
    _reader_book_subscription = insert(:reader_book_subscription, book: book, reader: reader)
    conn = log_in_author(conn, reader)
    {:ok, view, _html} = live(conn, Routes.book_read_path(conn, :index, book))

    view
    |> element("[data-test=remove-from-library-button]")
    |> render_click()

    {:ok, _view, html} = live(conn, Routes.dashboard_library_path(conn, :index))
    refute html =~ book.title
  end
end
