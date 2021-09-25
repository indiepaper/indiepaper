defmodule IndiePaperWeb.Feature.ReaderCanVisitAndBuyBookTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{BookPage, LoginPage, DashboardOrderPage}

  test "reader can visit book page and buy book", %{session: session} do
    book = insert(:book)
    customer = insert(:author)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: customer.email, password: customer.password)
    |> BookPage.Show.visit_page(book)
    |> BookPage.Show.has_buy_button?()

    # There is an issue with Stripe Mock, so for the time being we are going call the payment handler function by ourselves
    {:ok, _} = IndiePaper.PaymentHandler.get_checkout_session_url(customer, book)

    # Verify that an order is created
    session
    |> DashboardOrderPage.visit_page()
    |> DashboardOrderPage.has_book_title?(book.title)
    |> DashboardOrderPage.has_order_status?("Payment pending")
  end
end
