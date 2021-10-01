defmodule IndiePaper.Repo.Migrations.AddAmountToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :amount, :integer, null: false, default: 0
    end
  end
end
