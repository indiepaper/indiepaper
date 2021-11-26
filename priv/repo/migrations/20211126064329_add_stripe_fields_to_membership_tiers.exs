defmodule IndiePaper.Repo.Migrations.AddStripeFieldsToMembershipTiers do
  use Ecto.Migration

  import Ecto.Query
  alias IndiePaper.Repo

  def up do
    alter table(:membership_tiers) do
      add :stripe_product_id, :string
      add :stripe_price_id, :string
    end

    flush()

    from(a in "membership_tiers",
      update: [
        set: [
          stripe_product_id: fragment("substr(md5(random()::text), 0, 12)"),
          stripe_price_id: fragment("substr(md5(random()::text), 0, 12)")
        ]
      ]
    )
    |> Repo.update_all([])

    alter table(:membership_tiers) do
      modify :stripe_product_id, :string, null: false
      modify :stripe_price_id, :string, null: false
    end

    create unique_index(:membership_tiers, [:stripe_product_id])
    create unique_index(:membership_tiers, [:stripe_price_id])
  end

  def down do
    drop unique_index(:membership_tiers, [:stripe_product_id])
    drop unique_index(:membership_tiers, [:stripe_price_id])

    alter table(:authors) do
      remove :stripe_product_id
      remove :stripe_price_id
    end
  end
end
