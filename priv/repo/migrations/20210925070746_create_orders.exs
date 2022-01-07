defmodule IndiePaper.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :book_id, references(:books, on_delete: :nothing, type: :binary_id)
      add :reader_id, references(:authors, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:orders, [:book_id])
    create index(:orders, [:reader_id])
  end
end
