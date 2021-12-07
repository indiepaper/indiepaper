defmodule IndiePaper.BookLibrary do
  alias IndiePaper.Orders
  alias IndiePaper.ReaderBookSubscriptions

  def get_orders(customer) do
    Orders.list_orders(customer)
    |> load_order_assoc()
  end

  def list_payment_completed_orders(customer) do
    Orders.list_payment_completed_orders(customer)
    |> load_order_assoc()
  end

  def list_subscribed_books(reader) do
    book_subscriptions_with_books =
      ReaderBookSubscriptions.list_book_subscriptions(reader.id)
      |> ReaderBookSubscriptions.with_book()

    Enum.map(book_subscriptions_with_books, fn bs -> bs.book end)
  end

  defp load_order_assoc(orders),
    do: orders |> Orders.with_assoc([[book: :author], [line_items: [product: :assets]]])
end
