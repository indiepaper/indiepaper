defmodule IndiePaper.Repo.Migrations.AddTitleAndDescriptionToMembershipTiers do
  use Ecto.Migration

  def change do
    alter table(:membership_tiers) do
      add :title, :string, nil: false
      add :description_html, :text, nil: false
    end
  end
end
