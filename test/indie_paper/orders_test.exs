defmodule IndiePaper.OrdersTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Orders

  describe "list_orders/1" do
    test "lists orders for the given author" do
      reader = insert(:author)
      order1 = insert(:order, reader: reader)
      order2 = insert(:order)

      orders = Orders.list_orders(reader)

      assert Enum.find(orders, fn order -> order.id == order1.id end)
      refute Enum.find(orders, fn order -> order.id == order2.id end)
    end
  end

  describe "create_order_with_reader/2" do
    test "creates order and associates to reader" do
      product = insert(:product)
      book = insert(:book, products: [product])
      reader = insert(:author)

      {:ok, order} =
        Orders.create_order(reader, %{
          amount: 340,
          book_id: book.id,
          products: book.products,
          stripe_checkout_session_id: "checkout_session_id"
        })

      order_with_line_items = Orders.with_assoc(order, :line_items)
      line_item = Enum.at(order_with_line_items.line_items, 0)

      assert order.reader_id == reader.id
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

  describe "list_orders_of_author/1" do
    test "shows all orders from authors books" do
      author = insert(:author)
      author_book = insert(:book, author: author)
      book = insert(:book)

      insert(:order, book: author_book)
      insert(:order, book: book)

      orders = Orders.list_orders_of_author(author)

      assert Enum.any?(orders, fn order -> order.book_id == author_book.id end)
      refute Enum.any?(orders, fn order -> order.book_id == book.id end)
    end
  end
end
