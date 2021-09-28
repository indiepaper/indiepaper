defmodule IndiePaper.Repo.Migrations.RemoveUniqueIndexBookTitle do
  use Ecto.Migration

  def change do
    drop unique_index(:books, [:title])
  end
end
