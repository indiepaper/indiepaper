defmodule IndiePaper.Chapters.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:title, :id, :chapter_index]}
  schema "chapters" do
    field :title, :string
    field :chapter_index, :integer, null: false, default: 0
    field :content_json, :map
    field :published_content_json, :map
    field :is_free, :boolean, nil: false, default: false

    belongs_to :draft, IndiePaper.Drafts.Draft

    timestamps()
  end

  @doc false
  def changeset(chapter, attrs) do
    chapter
    |> cast(attrs, [:title, :chapter_index, :content_json])
    |> validate_required([:title, :chapter_index, :content_json])
    |> validate_number(:chapter_index, greater_than_or_equal_to: 0)
    |> validate_length(:title, max: 30)
  end

  def publish_changeset(chapter, attrs) do
    chapter
    |> cast(attrs, [:published_content_json, :is_free])
    |> validate_required([:published_content_json])
  end
end
