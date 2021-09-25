defmodule IndiePaper.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    belongs_to :book, IndiePaper.Books.Book
    belongs_to :customer, IndiePaper.Authors.Author

    has_many :line_items, IndiePaper.Orders.LineItem

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [])
    |> validate_required([])
  end
end
