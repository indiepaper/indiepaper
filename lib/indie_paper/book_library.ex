defmodule IndiePaper.BookLibrary do
  import Ecto.Query
  alias IndiePaper.Repo

  alias IndiePaper.Orders

  def get_orders(reader) do
    Orders.list_orders(reader)
    |> load_order_assoc()
  end

  def list_payment_completed_orders(reader) do
    Orders.list_payment_completed_orders(reader)
    |> load_order_assoc()
  end

  def book_added_to_library?(nil, _book), do: false

  def has_purchased_product?(reader, product) do
    from(l in Orders.LineItem,
      join: o in Orders.Order,
      on: o.id == l.order_id,
      where:
        l.product_id == ^product.id and o.reader_id == ^reader.id and
          o.status == :payment_completed
    )
    |> Repo.exists?()
  end

  def has_purchased_read_online_asset?(reader, book) do
    from(o in Orders.Order,
      join: l in assoc(o, :line_items),
      join: p in assoc(l, :product),
      join: a in assoc(p, :assets),
      where: a.type == ^:readable and o.reader_id == ^reader.id and a.book_id == ^book.id
    )
    |> Repo.exists?()
  end

  defp load_order_assoc(orders),
    do: orders |> Orders.with_assoc([[book: :author], [line_items: [product: :assets]]])
end
