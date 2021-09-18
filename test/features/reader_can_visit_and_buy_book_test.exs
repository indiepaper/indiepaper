defmodule IndiePaperWeb.Feature.ReaderCanVisitAndBuyBookTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{BookPage}

  test "reader can visit book page and buy book", %{session: session} do
    book = insert(:book)
    product = Enum.at(book.products, 0)

    session
    |> BookPage.Show.visit_page(book)
    |> BookPage.Show.select_product(product.title)
    |> BookPage.Show.click_buy_button()
  end
end
