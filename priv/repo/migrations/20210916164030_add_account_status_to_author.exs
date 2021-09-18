defmodule IndiePaper.Repo.Migrations.AddAccountStatusToAuthor do
  use Ecto.Migration

  def change do
    alter table(:authors) do
      add :account_status, :string, null: false, default: "created"
    end
  end
end
