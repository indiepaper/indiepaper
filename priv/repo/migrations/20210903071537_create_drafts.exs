defmodule IndiePaper.Repo.Migrations.CreateDrafts do
  use Ecto.Migration

  def change do
    create table(:drafts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string

      timestamps()
    end
  end
end
