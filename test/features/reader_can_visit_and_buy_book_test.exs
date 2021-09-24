defmodule IndiePaperWeb.Feature.ReaderCanVisitAndBuyBookTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{BookPage}

  test "reader can visit book page and buy book", %{session: session} do
    book = insert(:book)

    session
    |> BookPage.Show.visit_page(book)
    |> BookPage.Show.has_buy_button?()
  end
end
