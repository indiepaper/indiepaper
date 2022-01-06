defmodule IndiePaper.Repo.Migrations.RemoveMembershipTiersAndSubscriptions do
  use Ecto.Migration

  def change do
    drop table(:chapter_membership_tiers)
    drop table(:reader_author_subscriptions)
    drop table(:membership_tiers)
  end
end
