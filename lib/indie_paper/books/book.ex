defmodule IndiePaper.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "books" do
    field :long_description_html, :string
    field :short_description, :string
    field :title, :string
    belongs_to :author, IndiePaper.Authors.Author
    belongs_to :draft, IndiePaper.Drafts.Draft

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :short_description, :long_description_html])
    |> validate_required([:title, :short_description, :long_description_html])
    |> unique_constraint(:title)
  end
end
