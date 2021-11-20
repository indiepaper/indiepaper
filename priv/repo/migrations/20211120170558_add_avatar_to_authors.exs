defmodule IndiePaper.Repo.Migrations.AddAvatarToAuthors do
  use Ecto.Migration

  def change do
    alter table(:authors) do
      add :profile_picture, :string
    end
  end
end
