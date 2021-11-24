defmodule IndiePaper.MembershipTiers.MembershipTier do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "membership_tiers" do
    field :amount, :string
    belongs_to :author, IndiePaper.Authors.Author

    timestamps()
  end

  @doc false
  def changeset(membership_tier, attrs) do
    membership_tier
    |> cast(attrs, [:amount, :author_id])
    |> validate_required([:amount, :author_id])
  end
end
