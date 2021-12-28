defmodule IndiePaper.Repo.Migrations.CreateChapterProducts do
  use Ecto.Migration

  def change do
    create table(:chapter_products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :chapter_id, references(:chapters, on_delete: :nothing, type: :binary_id), null: false
      add :product_id, references(:products, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:chapter_products, [:chapter_id])
    create index(:chapter_products, [:product_id])
    create unique_index(:chapter_products, [:chapter_id, :product_id])
  end
end
