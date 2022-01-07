defmodule IndiePaperWeb.Feature.AuthorCanOrdersForBooksTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "author can see orders made for thier books", %{conn: conn} do
    author = insert(:author)
    conn = log_in_author(conn, author)
    book = insert(:book, author: author)

    insert(:order, book: book)

    {:ok, view, _html} = live(conn, Routes.dashboard_path(conn, :index))

    {:ok, _, html} =
      view
      |> element("[data-test=orders-link]")
      |> render_click()
      |> follow_redirect(conn, Routes.dashboard_orders_path(conn, :index))

    assert html =~ "Orders"
    assert html =~ book.title
  end
end
