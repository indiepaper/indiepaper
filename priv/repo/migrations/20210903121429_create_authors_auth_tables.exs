defmodule IndiePaper.Repo.Migrations.CreateAuthorsAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:authors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:authors, [:email])

    create table(:authors_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :author_id, references(:authors, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:authors_tokens, [:author_id])
    create unique_index(:authors_tokens, [:context, :token])
  end
end
