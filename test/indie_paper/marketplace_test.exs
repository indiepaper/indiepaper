defmodule IndiePaper.MarketplaceTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Marketplace

  describe "has_reader_bought_book?" do
    test "checks if author has bought book" do
      [order1, order2] = insert_pair(:order)

      assert Marketplace.has_reader_bought_book?(order1.reader, order1.book)
      refute Marketplace.has_reader_bought_book?(order1.reader, order2.book)
    end
  end
end
