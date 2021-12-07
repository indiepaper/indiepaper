defmodule IndiePaperWeb.Feature.ReaderCanSubscribeToBookTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "reader can subscribe to books", %{conn: conn} do
    reader = insert(:author)
    author = insert(:author)

    book =
      insert(:book, publishing_type: :serial, draft: build(:draft, chapters: [build(:chapter)]))

    conn = conn |> log_in_author(reader)

    html = get(conn, Routes.book_path(conn, :show, book)) |> html_response(200)

    assert html =~ "Start Reading"
  end
end
