defmodule IndiePaper.Repo.Migrations.AddAccountSetupFieldsToAuthor do
  use Ecto.Migration

  import Ecto.Query
  alias IndiePaper.Repo

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    alter table(:authors) do
      add :username, :citext
      add :first_name, :string
      add :last_name, :string
    end

    create unique_index(:authors, [:username])

    flush()

    from(a in "authors",
      update: [
        set: [
          username: fragment("substr(md5(random()::text), 0, 12)"),
          first_name: fragment("substr(md5(random()::text), 0, 12)")
        ]
      ]
    )
    |> Repo.update_all([])

    alter table(:authors) do
      modify :username, :citext, null: false, from: :citext
      modify :first_name, :string, null: false, from: :string
    end
  end

  def down do
    drop unique_index(:authors, [:username])

    alter table(:authors) do
      remove :username
      remove :first_name
      remove :last_name
    end
  end
end
