defmodule IndiePaperWeb.Feature.AuthorCanCreateSerialBooksTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "author can create serial books", %{conn: conn} do
    author = insert(:author)
    conn = log_in_author(conn, author)
    {:ok, view, _html} = live(conn, Routes.book_new_path(conn, :new))

    {:ok, conn} =
      view
      |> form("[data-test=new-book-form]",
        book: %{title: "Serial Novel"}
      )
      |> render_submit(%{publishing_type: :serial})
      |> follow_redirect(conn)

    html = html_response(conn, 200)

    assert html =~ "Serial Novel"
    assert html =~ "Publish Chapter"
  end
end
