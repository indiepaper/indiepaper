defmodule IndiePaper.Repo.Migrations.RemoveReaderBookSubscriptions do
  use Ecto.Migration

  def change do
    drop table(:reader_book_subscriptions)
  end
end
