defmodule IndiePaper.Drafts.Draft do
  @behaviour Bodyguard.Schema
  import Ecto.Query, only: [from: 2]

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "drafts" do
    field :title, :string
    has_many :chapters, IndiePaper.Chapters.Chapter, preload_order: [asc: :chapter_index]
    belongs_to :author, IndiePaper.Authors.Author

    timestamps()
  end

  def changeset(draft_or_changeset, attrs) do
    draft_or_changeset
    |> cast(attrs, [:title, :author_id])
    |> validate_required([:title])
    |> cast_or_constraint_assoc(:author)
  end

  def chapters_changeset(draft_or_changeset, chapters) do
    draft_or_changeset
    |> put_assoc(:chapters, chapters)
  end

  def scope(query, %IndiePaper.Authors.Author{id: author_id}, _) do
    from p in query, where: p.author_id == ^author_id
  end

  defp cast_or_constraint_assoc(changeset, name) do
    {:assoc, %{owner_key: key}} = changeset.types[name]

    if changeset.changes[key] do
      assoc_constraint(changeset, name)
    else
      cast_assoc(changeset, name, required: true)
    end
  end
end
