defmodule IndiePaper.Orders do
  alias IndiePaper.Repo
  import Ecto.Query

  alias IndiePaper.Orders.{Order, LineItem}

  def list_orders(%IndiePaper.Authors.Author{} = customer) do
    Order
    |> Bodyguard.scope(customer)
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def with_assoc(order, assoc) do
    order |> Repo.preload(assoc)
  end

  def create_order(customer, %{id: book_id, products: products}) do
    Ecto.build_assoc(customer, :orders)
    |> Order.changeset(%{book_id: book_id})
    |> Order.line_items_changeset(line_items_changeset(products))
    |> Repo.insert()
  end

  def change_line_item(line_item, attrs \\ %{}) do
    line_item
    |> LineItem.changeset(attrs)
  end

  def line_items_changeset(products) do
    Enum.map(products, fn product ->
      change_line_item(%LineItem{}, %{amount: product.price, product_id: product.id})
    end)
  end
end
