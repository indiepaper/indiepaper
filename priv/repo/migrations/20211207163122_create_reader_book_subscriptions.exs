defmodule IndiePaper.Repo.Migrations.CreateReaderBookSubscriptions do
  use Ecto.Migration

  def change do
    create table(:reader_book_subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :reader_id, references(:authors, on_delete: :nothing, type: :binary_id), null: false
      add :book_id, references(:books, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:reader_book_subscriptions, [:reader_id])
    create index(:reader_book_subscriptions, [:book_id])
    create unique_index(:reader_book_subscriptions, [:reader_id, :book_id])
  end
end
