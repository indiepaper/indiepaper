defmodule IndiePaper.Repo.Migrations.AddPublishedContentJsonToChapters do
  use Ecto.Migration

  def change do
    alter table(:chapters) do
      add :published_content_json, :map
    end
  end
end
