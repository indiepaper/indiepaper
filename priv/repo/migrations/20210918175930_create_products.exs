defmodule IndiePaper.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, nil: false
      add :description, :string, nil: false
      add :book_id, references(:books, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:products, [:book_id])
  end
end
