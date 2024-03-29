defmodule IndiePaperWeb.BookLive.NewTest do
  use IndiePaperWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  setup :register_and_log_in_author

  test "author can create new book", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.book_new_path(conn, :new))

    {:ok, _view, html} =
      view
      |> form("[data-test=new-book-form]", %{book: %{title: "Book Title"}})
      |> render_submit()
      |> follow_redirect(conn)

    assert html =~ "Book Title"
  end
end
