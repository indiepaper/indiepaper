defmodule IndiePaper.Repo.Migrations.AddStatusToBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :status, :string, default: "pending_publication", null: false
    end
  end
end
