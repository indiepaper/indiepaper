defmodule IndiePaper.Drafts.Draft do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "drafts" do
    field :title, :string
    has_many :chapters, IndiePaper.Chapters.Chapter, preload_order: [asc: :chapter_index]
    belongs_to :author, IndiePaper.Authors.Author
    belongs_to :book, IndiePaper.Books.Book

    timestamps()
  end

  def changeset(draft_or_changeset) do
    draft_or_changeset
    |> cast(%{}, [])
  end

  def chapters_changeset(draft_or_changeset, chapters) do
    draft_or_changeset
    |> put_assoc(:chapters, chapters)
  end
end
