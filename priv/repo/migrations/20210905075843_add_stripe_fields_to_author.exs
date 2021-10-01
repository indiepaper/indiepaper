defmodule IndiePaper.Repo.Migrations.AddStripeFieldsToAuthor do
  use Ecto.Migration

  def change do
    alter table(:authors) do
      add :stripe_connect_id, :string
      add :is_payment_connected, :boolean, default: false
    end

    create unique_index(:authors, [:stripe_connect_id])
  end
end
