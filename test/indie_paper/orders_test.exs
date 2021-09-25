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

  describe "create_order/2" do
    test "creates order and associates to customer" do
      product = insert(:product)
      book = insert(:book, products: [product])
      customer = insert(:author)

      {:ok, order} = Orders.create_order(customer, book)
      order_with_line_items = Orders.with_assoc(order, :line_items)
      line_item = Enum.at(order_with_line_items.line_items, 0)

      assert order.customer_id == customer.id
      assert order.book_id == book.id
      assert line_item.product_id == product.id
      assert line_item.amount == product.price
    end
  end
end
