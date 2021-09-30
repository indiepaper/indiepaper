defmodule IndiePaper.Orders do
  @behaviour Bodyguard.Policy

  def authorize(_, _, _), do: false

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

  def create_order(customer, attrs \\ %{}) do
    Ecto.build_assoc(customer, :orders)
    |> Order.changeset(attrs)
    |> Order.line_items_changeset(line_items_changeset(attrs[:products]))
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

  def update_order(order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  def get_by_stripe_checkout_session_id!(stripe_checkout_session_id),
    do: Repo.get_by!(Order, stripe_checkout_session_id: stripe_checkout_session_id)

  def set_payment_completed(order) do
    order
    |> update_order(%{status: :payment_completed})
  end

  def is_payment_completed?(%Order{status: :payment_completed}), do: true
  def is_payment_completed?(_), do: false
end
