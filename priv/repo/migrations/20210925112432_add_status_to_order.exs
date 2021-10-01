defmodule IndiePaper.Repo.Migrations.AddStatusToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :status, :string, default: "payment_pending", null: false
    end
  end
end
