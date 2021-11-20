defmodule IndiePaper.BookLibraryTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.BookLibrary

  describe "list_payment_completed_orders/1" do
    test "lists only payment completed orders for the given author" do
      customer = insert(:author)
      order1 = insert(:order, customer: customer)
      order2 = insert(:order, customer: customer, status: :payment_pending)

      orders = BookLibrary.list_payment_completed_orders(customer)

      assert Enum.find(orders, fn order -> order.id == order1.id end)
      refute Enum.find(orders, fn order -> order.id == order2.id end)
    end
  end
end
