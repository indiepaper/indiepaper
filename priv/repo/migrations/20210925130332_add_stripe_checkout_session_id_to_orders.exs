defmodule IndiePaper.Repo.Migrations.AddStripeCheckoutSessionIdToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :stripe_checkout_session_id, :string
    end

    flush()

    IndiePaper.Repo.update_all("orders",
      set: [stripe_checkout_session_id: "dummy_checkout_session_id"]
    )

    alter table(:orders) do
      modify :stripe_checkout_session_id, :string, null: false
    end
  end
end
