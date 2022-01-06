defmodule IndiePaper.Repo.Migrations.MakePreOrderBooksDefault do
  use Ecto.Migration

  def change do
    alter table(:books) do
      modify :publishing_type, :string, null: false, default: "pre_order", from: :string
    end
  end
end
