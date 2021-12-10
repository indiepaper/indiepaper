defmodule IndiePaper.Repo.Migrations.AddIsFreeToChapters do
  use Ecto.Migration

  def change do
    alter table(:chapters) do
      add :is_free, :boolean, null: false, default: false
    end
  end
end
