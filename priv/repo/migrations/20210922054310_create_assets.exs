defmodule IndiePaper.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string, null: false
      add :book_id, references(:books, on_delete: :delete_all, type: :binary_id)
      add :title, :string, null: false

      timestamps()
    end

    create index(:assets, [:book_id])
  end
end
