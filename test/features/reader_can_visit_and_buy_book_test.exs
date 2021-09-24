defmodule IndiePaperWeb.Feature.ReaderCanVisitAndBuyBookTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{BookPage}

  test "reader can visit book page and buy book", %{session: session} do
    book = insert(:book)

    stripe_checkout_url =
      session
      |> BookPage.Show.visit_page(book)
      |> BookPage.Show.click_buy_button()
      |> current_url()

    stripe_checkout_uri = URI.parse(stripe_checkout_url)

    assert String.contains?(stripe_checkout_uri.host, "stripe.me")
  end
end
