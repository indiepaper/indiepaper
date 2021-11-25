defmodule IndiePaper.MembershipTiers.MembershipTier do
  @behaviour Bodyguard.Schema

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "membership_tiers" do
    field :title, :string, nil: false
    field :description_html, :string, nil: false
    field :amount, Money.Ecto.Amount.Type

    belongs_to :author, IndiePaper.Authors.Author

    timestamps()
  end

  @doc false
  def changeset(membership_tier, attrs) do
    membership_tier
    |> cast(attrs, [:amount, :title, :description_html])
    |> validate_required([:amount, :title, :description_html])
  end

  def scope(query, %IndiePaper.Authors.Author{id: author_id}, _) do
    from p in query, where: p.author_id == ^author_id
  end
end
