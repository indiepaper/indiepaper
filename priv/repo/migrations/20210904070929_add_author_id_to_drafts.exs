defmodule IndiePaper.Repo.Migrations.AddAuthorIdToDrafts do
  use Ecto.Migration

  def change do
    alter table(:drafts) do
      add :author_id, references(:authors, on_delete: :delete_all, type: :binary_id), null: false
    end

    create index(:drafts, [:author_id])
  end
end
