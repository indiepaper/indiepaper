defmodule IndiePaperWeb.Feature.ReaderCanSubscribeToBookTest do
  use IndiePaperWeb.ConnCase, async: true

  test "reader can read books", %{conn: conn} do
    reader = insert(:author)
    book = insert(:book, publishing_type: :pre_order)

    conn = conn |> log_in_author(reader)

    html = get(conn, Routes.book_show_path(conn, :show, book)) |> html_response(200)

    assert html =~ "Start Reading"
  end
end
