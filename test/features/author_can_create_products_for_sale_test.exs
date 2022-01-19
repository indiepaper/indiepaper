defmodule IndiePaperWeb.Features.AuthorCanCreateProductsForSaleTest do
  use IndiePaperWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  test "author can create products", %{conn: conn} do
    book = insert(:book, products: [])
    product_params = params_for(:product, assets: nil)
    conn = log_in_author(conn, book.author)
    {:ok, view, _html} = live(conn, Routes.dashboard_path(conn, :index))

    {:ok, product_view, _html} =
      view
      |> element("[data-test=add-new-product")
      |> render_click()
      |> follow_redirect(conn, Routes.book_product_new_path(conn, :new, book))

    {:ok, _view, html} =
      product_view
      |> form("#product-form", %{product: product_params})
      |> render_submit()
      |> follow_redirect(conn, Routes.dashboard_path(conn, :index))

    assert html =~ product_params[:title]
  end

  test "author can update products", %{conn: conn} do
    book = insert(:book, products: [])
    product = insert(:product, book: book)
    conn = log_in_author(conn, book.author)

    {:ok, view, _html} = live(conn, Routes.book_product_edit_path(conn, :edit, book, product))

    {:ok, _view, html} =
      view
      |> form("#product-form", %{product: %{title: "Updated title"}})
      |> render_submit()
      |> follow_redirect(conn, Routes.dashboard_path(conn, :index))

    assert html =~ "Updated title"
  end
end
