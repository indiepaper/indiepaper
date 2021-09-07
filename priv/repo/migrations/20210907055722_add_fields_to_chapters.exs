defmodule IndiePaper.Repo.Migrations.AddFieldsToChapters do
  use Ecto.Migration

  def change do
    alter table(:chapters) do
      add :chapter_index, :integer, null: false, default: 0
      add :content_json, :map, null: false
    end
  end
end
