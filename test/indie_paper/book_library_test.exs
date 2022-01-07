defmodule IndiePaper.BookLibraryTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.BookLibrary

  describe "list_payment_completed_orders/1" do
    test "lists only payment completed orders for the given author" do
      reader = insert(:author)
      order1 = insert(:order, reader: reader)
      order2 = insert(:order, reader: reader, status: :payment_pending)

      orders = BookLibrary.list_payment_completed_orders(reader)

      assert Enum.find(orders, fn order -> order.id == order1.id end)
      refute Enum.find(orders, fn order -> order.id == order2.id end)
    end
  end

  describe "has_purchased_product?/2" do
    test "returns true if the author has purchased product" do
    end
  end
end
