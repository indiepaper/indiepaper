defmodule IndiePaper.Repo.Migrations.AddUrlToAssets do
  use Ecto.Migration

  def change do
    alter table(:assets) do
      add :url, :string
    end
  end
end
