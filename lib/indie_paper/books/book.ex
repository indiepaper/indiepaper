defmodule IndiePaper.Books.Book do
  @behaviour Bodyguard.Schema
  import Ecto.Query, only: [from: 2]

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "books" do
    field :title, :string

    field :status, Ecto.Enum,
      values: [
        :pending_publication,
        :listing_complete,
        :publication_in_progress,
        :published,
        :delisted,
        :removed
      ],
      default: :pending_publication,
      nil: false

    field :short_description, :string
    field :long_description_html, :string

    has_one :draft, IndiePaper.Drafts.Draft
    belongs_to :author, IndiePaper.Authors.Author

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :short_description, :long_description_html])
    |> validate_required([:title, :short_description, :long_description_html])
    |> unique_constraint(:title)
  end

  def initial_draft_changeset(book, attrs) do
    book
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end

  def scope(query, %IndiePaper.Authors.Author{id: author_id}, _) do
    from p in query, where: p.author_id == ^author_id
  end
end
