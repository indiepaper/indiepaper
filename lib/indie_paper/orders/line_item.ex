defmodule IndiePaper.Orders.LineItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "line_items" do
    field :amount, Money.Ecto.Amount.Type
    belongs_to :product, IndiePaper.Products.Product
    belongs_to :order, IndiePaper.Orders.Order

    timestamps()
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:amount, :product_id])
    |> validate_required([:amount, :product_id])
  end
end
