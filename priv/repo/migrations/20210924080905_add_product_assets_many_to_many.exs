defmodule IndiePaper.Repo.Migrations.AddProductAssetsManyToMany do
  use Ecto.Migration

  def change do
    create table(:product_assets) do
      add :product_id, references(:products, on_delete: :nothing, type: :binary_id)
      add :asset_id, references(:assets, on_delete: :nothing, type: :binary_id)
    end

    create index(:product_assets, [:product_id])
  end
end
