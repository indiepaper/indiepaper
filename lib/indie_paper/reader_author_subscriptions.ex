defmodule IndiePaper.ReaderAuthorSubscriptions do
  alias IndiePaper.Repo
  import Ecto.Query

  alias IndiePaper.ReaderAuthorSubscriptions.ReaderAuthorSubscription
  alias IndiePaper.MembershipTiers

  def create_reader_author_subscription!(params) do
    %ReaderAuthorSubscription{}
    |> ReaderAuthorSubscription.changeset(params)
    |> Repo.insert!()
  end

  def get_subscription_by_reader_author_id(reader_id, author_id) do
    from(s in ReaderAuthorSubscription,
      where: s.reader_id == ^reader_id,
      join: m in MembershipTiers.MembershipTier,
      on: m.id == s.membership_tier_id,
      where: m.author_id == ^author_id
    )
    |> Repo.one()
    |> Repo.preload([:reader, :membership_tier])
  end

  def list_subscriptions_of_reader(reader_id) do
    from(s in ReaderAuthorSubscription, where: s.reader_id == ^reader_id) |> Repo.all()
  end
end
