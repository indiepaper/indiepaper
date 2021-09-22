defmodule IndiePaper.Assets.Asset do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "assets" do
    field :type, Ecto.Enum, values: [:readable]
    belongs_to :book, IndiePaper.Books.Book

    timestamps()
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end
end
