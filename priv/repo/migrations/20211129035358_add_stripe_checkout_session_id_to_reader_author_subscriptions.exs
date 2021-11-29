defmodule IndiePaper.Repo.Migrations.AddStripeCheckoutSessionIdToReaderAuthorSubscriptions do
  use Ecto.Migration

  def change do
    alter table(:reader_author_subscriptions) do
      add :stripe_checkout_session_id, :string, null: false
    end

    create unique_index(:reader_author_subscriptions, [:stripe_checkout_session_id])
  end
end
