defmodule IndiePaper.BookLibrary do
  import Ecto.Query
  alias IndiePaper.Repo

  alias IndiePaper.Orders
  alias IndiePaper.Products
  alias IndiePaper.ReaderBookSubscriptions
  alias IndiePaper.Books

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

    Enum.map(book_subscriptions_with_books, fn bs -> bs.book end) |> Books.with_assoc(:author)
  end

  def book_added_to_library?(nil, _book), do: false

  def book_added_to_library?(reader, book) do
    ReaderBookSubscriptions.get_reader_book_subscription(reader.id, book.id)
  end

  def has_purchased_product?(reader, product) do
    from(l in Orders.LineItem,
      join: o in Orders.Order,
      on: o.id == l.order_id,
      where: l.product_id == ^product.id and o.customer_id == ^reader.id
    )
    |> Repo.exists?()
  end

  defp load_order_assoc(orders),
    do: orders |> Orders.with_assoc([[book: :author], [line_items: [product: :assets]]])
end
