defmodule IndiePaper.Drafts.Draft do
  @behaviour Bodyguard.Schema
  import Ecto.Query, only: [from: 2]

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "drafts" do
    field :title, :string
    has_many :chapters, IndiePaper.Drafts.Chapter
    belongs_to :author, IndiePaper.Authors.Author

    timestamps()
  end

  def changeset(draft_or_changeset, attrs) do
    draft_or_changeset
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end

  def scope(query, %IndiePaper.Authors.Author{id: author_id}, _) do
    from p in query, where: p.author_id == ^author_id
  end
end
