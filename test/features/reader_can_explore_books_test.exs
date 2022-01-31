defmodule IndiePaperWeb.Feature.ReaderCanExploreBooks do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "reader can explore published books", %{conn: conn} do
    book = insert(:book, status: :published)
    unpublished_book = insert(:book, status: :pending_publication)
    {:ok, _live, html} = live(conn, Routes.explore_path(conn, :index))

    assert html =~ "Explore"
    assert html =~ book.title
    refute html =~ unpublished_book.title
  end
end
