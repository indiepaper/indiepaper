defmodule IndiePaper.Repo.Migrations.AddPromoImagesToBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :promo_images, {:array, :string}, null: false, default: []
    end
  end
end
