defmodule IndiePaper.Repo.Migrations.AddPublishingTypeToBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :publishing_type, :string, null: false, default: "vanilla"
    end
  end
end
