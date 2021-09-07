defmodule IndiePaper.Chapters.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chapters" do
    field :title, :string
    field :draft_id, :binary_id
    field :chapter_index, :integer, nil: false, default: 0
    field :content_json, :map

    timestamps()
  end

  @doc false
  def changeset(chapter, attrs) do
    chapter
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
