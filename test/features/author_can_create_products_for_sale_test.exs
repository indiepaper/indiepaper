defmodule IndiePaperWeb.Features.AuthorCanCreateProductsForSaleTest do
  use IndiePaperWeb.FeatureCase, async: false

  alias IndiePaperWeb.Pages.{LoginPage, DashboardPage, BookPage, ProductPage}

  @tag :skip
  test "author can create and edit products for sale", %{session: session} do
    book = insert(:book, products: [])
    product_params = params_for(:product)
    update_product_params = params_for(:product)

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: book.author.email, password: book.author.password)
    |> DashboardPage.click_add_product()
    |> ProductPage.fill_form(product_params)
    |> ProductPage.click_save_product()
    |> DashboardPage.has_product_title?(product_params[:title])
    |> DashboardPage.has_product_price?(product_params[:price])
    |> DashboardPage.click_edit_product(product_params[:title])
    |> ProductPage.fill_form(update_product_params)
    |> ProductPage.click_read_online_asset()
    |> ProductPage.click_save_product()
    |> DashboardPage.has_product_title?(update_product_params[:title])
    |> DashboardPage.has_product_price?(update_product_params[:price])
    |> BookPage.Show.visit_page(book)
    |> BookPage.Show.select_product(update_product_params[:title])
  end
end
