defmodule IndiePaper.Repo.Migrations.MakeReaderAsReader do
  use Ecto.Migration

  def change do
    rename table(:orders), :customer_id, to: :reader_id
  end
end
