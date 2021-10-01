defmodule IndiePaper.Repo.Migrations.AddAuthorIdToBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :author_id, references(:authors, on_delete: :delete_all, type: :binary_id)
    end

    create index(:books, [:author_id])
  end
end
