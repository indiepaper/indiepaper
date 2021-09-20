defmodule IndiePaper.Repo.Migrations.AddAmountToProducts do
  use Ecto.Migration

  def change do
    execute "CREATE TYPE public.money_with_currency AS (amount integer, currency char(3))"

    alter table(:products) do
      add :price, :money_with_currency, null: false
    end
  end
end
