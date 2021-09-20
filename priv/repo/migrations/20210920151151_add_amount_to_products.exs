defmodule IndiePaper.Repo.Migrations.AddAmountToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :price, :integer, null: false, default: 0
    end
  end
end
