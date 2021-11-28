defmodule IndiePaper.Repo.Migrations.CreateReaderAuthorSubscriptions do
  use Ecto.Migration

  def change do
    create table(:reader_author_subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :reader_id, references(:authors, on_delete: :nothing, type: :binary_id), null: false
      add :author_id, references(:authors, on_delete: :nothing, type: :binary_id), null: false
      add :status, :string, null: false, default: "inactive"

      add :membership_tier_id,
          references(:membership_tiers, on_delete: :nothing, type: :binary_id),
          null: false

      timestamps()
    end

    create index(:reader_author_subscriptions, [:reader_id])
    create index(:reader_author_subscriptions, [:author_id])
    create index(:reader_author_subscriptions, [:membership_tier_id])

    create unique_index(:reader_author_subscriptions, [:reader_id, :author_id])
  end
end
