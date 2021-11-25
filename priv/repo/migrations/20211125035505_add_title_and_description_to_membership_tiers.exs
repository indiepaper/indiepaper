defmodule IndiePaper.Repo.Migrations.AddTitleAndDescriptionToMembershipTiers do
  use Ecto.Migration

  def change do
    alter table(:membership_tiers) do
      add :title, :string, null: false
      add :description_html, :text, null: false
    end
  end
end
