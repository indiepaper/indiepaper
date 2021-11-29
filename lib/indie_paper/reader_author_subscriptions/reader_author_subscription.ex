defmodule IndiePaper.ReaderAuthorSubscriptions.ReaderAuthorSubscription do
  use Ecto.Schema
  import Ecto.Changeset

  alias IndiePaper.MembershipTiers

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "reader_author_subscriptions" do
    belongs_to :reader, IndiePaper.Authors.Author
    belongs_to :author, IndiePaper.Authors.Author
    belongs_to :membership_tier, IndiePaper.MembershipTiers.MembershipTier

    field :stripe_checkout_session_id, :string

    field :status, Ecto.Enum,
      values: [
        :inactive,
        :active,
        :cancelled,
        :failed
      ],
      default: :inactive,
      nil: false

    timestamps()
  end

  @doc false
  def changeset(reader_author_subscription, attrs) do
    reader_author_subscription
    |> cast(attrs, [
      :reader_id,
      :membership_tier_id,
      :status,
      :stripe_checkout_session_id
    ])
    |> put_author_id()
    |> validate_required([
      :author_id,
      :reader_id,
      :membership_tier_id,
      :status,
      :stripe_checkout_session_id
    ])
    |> unique_constraint(:author_id, name: :reader_author_subscriptions_reader_id_author_id_index)
  end

  defp put_author_id(changeset) do
    case get_change(changeset, :membership_tier_id) do
      nil ->
        changeset

      membership_tier_id ->
        membership_tier = MembershipTiers.get_membership_tier!(membership_tier_id)
        put_change(changeset, :author_id, membership_tier.author_id)
    end
  end
end