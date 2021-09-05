defmodule IndiePaper.Drafts.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chapters" do
    field :title, :string
    field :draft_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(chapter, attrs) do
    chapter
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
