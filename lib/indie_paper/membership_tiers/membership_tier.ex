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
    field :amount, Money.Ecto.Amount.Type, nil: false, default: Money.new(100)

    field :stripe_product_id, :string
    field :stripe_price_id, :string

    belongs_to :author, IndiePaper.Authors.Author

    timestamps()
  end

  @doc false
  def changeset(membership_tier, attrs) do
    membership_tier
    |> cast(attrs, [:amount, :title, :description_html])
    |> validate_required([
      :amount,
      :title,
      :description_html
    ])
    |> validate_length(:title, min: 3, max: 32)
    |> validate_length(:description_html, min: 4, max: 512)
    |> validate_money(:amount)
  end

  def stripe_fields_changeset(membership_tier, attrs) do
    membership_tier
    |> cast(attrs, [:stripe_product_id, :stripe_price_id])
    |> validate_required([:stripe_product_id, :stripe_price_id])
  end

  def scope(query, %IndiePaper.Authors.Author{id: author_id}, _) do
    from p in query, where: p.author_id == ^author_id
  end

  defp validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: amount} when amount >= 1000 * 100 -> [amount: "must be less than $1000"]
      _, %Money{amount: amount} when amount > 99 -> []
      _, _ -> [amount: "must be atleast $1.00"]
    end)
  end
end
