defmodule IndiePaper.Orders.Order do
  @behaviour Bodyguard.Schema
  import Ecto.Query, only: [from: 2]

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :stripe_checkout_session_id, :string, nil: false
    field :amount, Money.Ecto.Amount.Type

    belongs_to :book, IndiePaper.Books.Book
    belongs_to :customer, IndiePaper.Authors.Author

    has_many :line_items, IndiePaper.Orders.LineItem

    field :status, Ecto.Enum,
      values: [
        :payment_pending,
        :payment_completed
      ],
      default: :payment_pending,
      nil: false

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:customer_id, :book_id, :stripe_checkout_session_id, :status, :amount])
    |> validate_required([:customer_id, :book_id, :stripe_checkout_session_id, :amount])
  end

  def line_items_changeset(order, line_items) do
    order
    |> Ecto.Changeset.put_assoc(:line_items, line_items)
  end

  def scope(query, %IndiePaper.Authors.Author{id: customer_id}, _) do
    from p in query, where: p.customer_id == ^customer_id
  end
end
