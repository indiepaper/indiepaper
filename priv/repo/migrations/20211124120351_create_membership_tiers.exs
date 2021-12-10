defmodule IndiePaper.Repo.Migrations.CreateMembershipTiers do
  use Ecto.Migration

  def change do
    create table(:membership_tiers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :integer, null: false, default: 100
      add :author_id, references(:authors, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:membership_tiers, [:author_id])
  end
end
