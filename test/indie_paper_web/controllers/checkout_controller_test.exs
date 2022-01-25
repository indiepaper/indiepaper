defmodule IndiePaperWeb.CheckoutControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  test "Cannot checkout your own book", %{conn: conn} do
    author = insert(:author)
    book = insert(:book, author: author)
    product = insert(:product, book: book)
    conn = log_in_author(conn, author)

    conn = conn |> get(Routes.book_checkout_path(conn, :new, book, product))
    redir_path = redirected_to(conn, 302)

    assert Routes.book_show_path(conn, :show, book) =~ redir_path

    html = get(recycle(conn), redir_path) |> html_response(200)
    assert html =~ "cannot buy your own book"
  end
end
