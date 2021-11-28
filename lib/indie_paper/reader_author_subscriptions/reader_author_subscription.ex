defmodule IndiePaper.ReaderAuthorSubscriptions.ReaderAuthorSubscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "reader_author_subscriptions" do
    belongs_to :reader, IndiePaper.Authors.Author
    belongs_to :author, IndiePaper.Authors.Author
    belongs_to :membership_tier, IndiePaper.MembershipTiers.MembershipTier

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
    |> cast(attrs, [:author_id, :reader_id, :membership_tier_id, :status])
    |> validate_required([:author_id, :reader_id, :membership_tier_id, :status])
    |> unique_constraint(:author_id, name: :reader_author_subscriptions_reader_id_author_id_index)
  end
end
