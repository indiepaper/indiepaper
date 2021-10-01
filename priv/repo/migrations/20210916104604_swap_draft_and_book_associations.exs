defmodule IndiePaper.Repo.Migrations.SwapDraftAndBookAssociations do
  use Ecto.Migration

  def change do
    alter table(:drafts) do
      add :book_id, references(:books, on_delete: :nothing, type: :binary_id)
    end

    alter table(:books) do
      remove :draft_id
    end

    create index(:drafts, [:book_id])
  end
end
