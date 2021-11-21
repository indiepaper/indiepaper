defmodule IndiePaper.Repo.Migrations.AddAvatarToAuthors do
  use Ecto.Migration

  def change do
    alter table(:authors) do
      add :profile_picture, :string,
        null: false,
        default: "public/profile_pictures/placeholder.png"
    end
  end
end
