defmodule IndiePaper.ReaderBookSubscriptions.ReaderBookSubscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "reader_book_subscriptions" do
    belongs_to :reader, IndiePaper.Authors.Author
    belongs_to :book, IndiePaper.Books.Book

    timestamps()
  end

  @doc false
  def changeset(reader_book_subscription, attrs) do
    reader_book_subscription
    |> cast(attrs, [:reader_id, :book_id])
    |> validate_required([:reader_id, :book_id])
    |> unique_constraint(:book_id, name: :reader_book_subscriptions_reader_id_book_id_index)
  end
end
