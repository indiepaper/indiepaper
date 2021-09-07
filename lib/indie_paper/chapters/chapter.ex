defmodule IndiePaper.Chapters.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chapters" do
    field :title, :string
    field :draft_id, :binary_id
    field :chapter_index, :integer, null: false, default: 0
    field :content_json, :map

    timestamps()
  end

  @doc false
  def changeset(chapter, attrs) do
    chapter
    |> cast(attrs, [:title, :chapter_index, :content_json])
    |> validate_required([:title, :chapter_index, :content_json])
    |> validate_number(:chapter_index, greater_than_or_equal_to: 0)
  end
end
