defmodule IndiePaper.OrdersTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Orders

  describe "list_orders/1" do
    test "lists orders for the given author" do
      customer = insert(:author)
      order1 = insert(:order, customer: customer)
      order2 = insert(:order)

      orders = Orders.list_orders(customer)

      assert Enum.find(orders, fn order -> order.id == order1.id end)
      refute Enum.find(orders, fn order -> order.id == order2.id end)
    end
  end
end
