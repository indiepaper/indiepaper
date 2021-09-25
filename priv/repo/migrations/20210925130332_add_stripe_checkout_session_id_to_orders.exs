defmodule IndiePaper.Repo.Migrations.AddStripeCheckoutSessionIdToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :stripe_checkout_session_id, :string, null: false
    end
  end
end
