defmodule IndiePaper.Drafts.Draft do
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
end
