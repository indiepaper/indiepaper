defmodule IndiePaper.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :description, :string
    field :title, :string, nil: false
    field :price, Money.Ecto.Amount.Type

    belongs_to :book, IndiePaper.Books.Book
    many_to_many :assets, IndiePaper.Assets.Asset, join_through: "product_assets"

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :price])
    |> validate_required([:title, :description, :price])
    |> validate_money(:price)
  end

  def asset_changeset(product, asset) do
    product
    |> Ecto.Changeset.put_assoc(:assets, [asset])
  end

  def validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: amount} when amount > 0 -> []
      _, _ -> [price: "must be greater than 0"]
    end)
  end
end
