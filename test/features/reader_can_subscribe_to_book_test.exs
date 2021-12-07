defmodule IndiePaperWeb.Feature.ReaderCanSubscribeToBookTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "reader can read books", %{conn: conn} do
    reader = insert(:author)
    book = insert(:book, publishing_type: :serial)

    conn = conn |> log_in_author(reader)

    html = get(conn, Routes.book_path(conn, :show, book)) |> html_response(200)

    assert html =~ "Start Reading"
  end

  test "reader can add book to library", %{conn: conn} do
    reader = insert(:author)
    book = insert(:book, publishing_type: :serial)
    conn = conn |> log_in_author(reader)
    {:ok, view, _html} = live(conn, Routes.book_read_path(conn, :index, book))

    view
    |> element("[data-test=add-to-library-button]")
    |> render_click()

    {:ok, _view, html} = live(conn, Routes.dashboard_library_path(conn, :index))
    assert html =~ book.title
  end
end
