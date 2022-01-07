defmodule IndiePaper.Repo.Migrations.AddStripeReaderIdToAuthors do
  use Ecto.Migration

  def change do
    alter table(:authors) do
      add :stripe_customer_id, :string
    end

    create unique_index(:authors, [:stripe_customer_id])
  end
end
