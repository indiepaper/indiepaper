defmodule IndiePaper.Repo.Migrations.AddFieldsToChapters do
  use Ecto.Migration

  def change do
    alter table(:chapters) do
      add :chapter_index, :integer, nil: false, default: 0
      add :content_json, :map, nil: false
    end
  end
end
