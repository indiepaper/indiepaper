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

  describe "create_order_with_customer/2" do
    test "creates order and associates to customer" do
      product = insert(:product)
      book = insert(:book, products: [product])
      customer = insert(:author)

      {:ok, order} =
        Orders.create_order(customer, %{
          amount: 340,
          book_id: book.id,
          products: book.products,
          stripe_checkout_session_id: "checkout_session_id"
        })

      order_with_line_items = Orders.with_assoc(order, :line_items)
      line_item = Enum.at(order_with_line_items.line_items, 0)

      assert order.customer_id == customer.id
      assert order.stripe_checkout_session_id == "checkout_session_id"
      assert order.book_id == book.id
      assert line_item.product_id == product.id
      assert line_item.amount == product.price
      assert order.amount.amount == 340
    end
  end

  describe "update_order" do
    test "updates order" do
      order = insert(:order, status: :payment_pending)

      {:ok, order} = Orders.update_order(order, %{status: :payment_completed})

      assert order.status == :payment_completed
    end
  end
end
