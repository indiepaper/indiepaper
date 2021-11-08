defmodule IndiePaper.Repo.Migrations.AddAccountSetupFieldsToAuthor do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    alter table(:authors) do
      add :username, :citext, null: false
      add :first_name, :string, null: false
      add :last_name, :string
    end

    create unique_index(:authors, [:username])
  end
end
