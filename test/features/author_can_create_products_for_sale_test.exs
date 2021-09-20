defmodule IndiePaperWeb.Features.AuthorCanCreateProductsForSaleTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{LoginPage, DashboardPage, BookPage, ProductPage}

  test "author can create products for sale", %{session: session} do
    book = insert(:book, products: [])
    product_params = params_for(:product)

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: book.author.email, password: book.author.password)
    |> DashboardPage.click_add_product()
    |> ProductPage.New.fill_form(product_params)
    |> ProductPage.New.click_add_product()
    |> DashboardPage.has_product_title?(product_params[:title])
    |> DashboardPage.has_product_price?(product_params[:price])
    |> BookPage.Show.visit_page(book)
    |> BookPage.Show.select_product(product_params[:title])
  end
end
