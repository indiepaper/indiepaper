defmodule IndiePaper.Repo.Migrations.AddMissingIndexesProductAssets do
  use Ecto.Migration

  def change do
    create index(:product_assets, [:asset_id])
    create unique_index(:product_assets, [:product_id, :asset_id])
  end
end
