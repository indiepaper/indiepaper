defmodule IndiePaper.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :short_description, :text
      add :long_description_html, :text
      add :author_id, references(:authors, on_delete: :delete_all, type: :binary_id)
      add :draft_id, references(:drafts, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:books, [:title])
    create index(:books, [:author_id])
    create index(:books, [:draft_id])
  end
end
