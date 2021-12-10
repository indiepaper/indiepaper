defmodule IndiePaper.Repo.Migrations.CreateChapterMembershipTiers do
  use Ecto.Migration

  def change do
    create table(:chapter_membership_tiers, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :membership_tier_id,
          references(:membership_tiers, on_delete: :nothing, type: :binary_id),
          null: false

      add :chapter_id, references(:chapters, on_delete: :nothing, type: :binary_id), null: false
    end

    create index(:chapter_membership_tiers, [:membership_tier_id])
    create index(:chapter_membership_tiers, [:chapter_id])
    create unique_index(:chapter_membership_tiers, [:chapter_id, :membership_tier_id])
  end
end
