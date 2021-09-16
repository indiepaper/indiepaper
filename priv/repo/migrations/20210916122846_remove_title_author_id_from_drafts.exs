defmodule IndiePaper.Repo.Migrations.RemoveTitleAuthorIdFromDrafts do
  use Ecto.Migration

  def change do
    alter table(:drafts) do
      remove :title
      remove :author_id
    end
  end
end
