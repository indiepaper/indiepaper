defmodule IndiePaper.Drafts.Draft do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "drafts" do
    field :title, :string

    timestamps()
  end
end
