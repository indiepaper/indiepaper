defmodule IndiePaperWeb.Feature.ReaderCanVisitAndBuyBookTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{BookPage, LoginPage, DashboardOrderPage}

  test "reader can visit book page and buy book", %{session: session} do
    book = insert(:book)
    product = insert(:product)
    line_item = insert(:line_item, product: product)
    order = insert(:order, line_items: [line_item])

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: order.customer.email, password: order.customer.password)
    |> BookPage.Show.visit_page(book)
    |> BookPage.Show.has_buy_button?()
    |> DashboardOrderPage.visit_page()
    |> DashboardOrderPage.has_book_title?(order.book.title)
    |> DashboardOrderPage.has_product_title?(product.title)
  end
end
