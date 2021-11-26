defmodule IndiePaper.Repo.Migrations.AddStripeFieldsToMembershipTiers do
  use Ecto.Migration

  def change do
    alter table(:membership_tiers) do
      add :stripe_product_id, :string
      add :stripe_price_id, :string
    end

    create unique_index(:membership_tiers, [:stripe_product_id])
    create unique_index(:membership_tiers, [:stripe_price_id])
  end
end
