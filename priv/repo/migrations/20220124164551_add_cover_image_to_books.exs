defmodule IndiePaper.Repo.Migrations.AddCoverImageToBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :cover_image, :string, null: false, default: "public/cover_images/placeholder.png"
      remove :promo_images
    end
  end
end
