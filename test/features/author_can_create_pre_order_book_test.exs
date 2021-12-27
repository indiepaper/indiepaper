defmodule IndiePaperWeb.Feature.AuthorCanCreatePreOrderBooksTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "Author can go to book creation page and select Pre Order", %{conn: conn} do
    author = insert(:author)
    conn = log_in_author(conn, author)

    {:ok, view, html} = live(conn, Routes.book_new_path(conn, :new))

    assert html =~ "Pre-order Book"

    {:ok, conn} =
      view
      |> form("[data-test=new-book-form]",
        book: %{title: "Preorder Book"}
      )
      |> render_submit(%{book: %{"publishing_type" => "pre_order"}})
      |> follow_redirect(conn)

    html = html_response(conn, 200)

    assert html =~ "Preorder Book"
    assert html =~ "Publish Chapter"
  end
end
