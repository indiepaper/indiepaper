defmodule IndiePaper.Repo.Migrations.CreateChapters do
  use Ecto.Migration

  def change do
    create table(:chapters, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :draft_id, references(:drafts, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:chapters, [:draft_id])
  end
end
