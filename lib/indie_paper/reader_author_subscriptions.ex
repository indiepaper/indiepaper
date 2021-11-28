defmodule IndiePaper.ReaderAuthorSubscriptions do
  alias IndiePaper.Repo
  alias IndiePaper.ReaderAuthorSubscriptions.ReaderAuthorSubscription

  alias IndiePaper.Authors
  alias IndiePaper.MembershipTiers

  def create_reader_author_subscription!(
        reader: %Authors.Author{id: reader_id},
        membership_tier: %MembershipTiers.MembershipTier{
          id: membership_tier_id,
          author_id: author_id
        },
        stripe_checkout_session_id: stripe_checkout_session_id
      ) do
    %ReaderAuthorSubscription{}
    |> ReaderAuthorSubscription.changeset(%{
      reader_id: reader_id,
      author_id: author_id,
      membership_tier_id: membership_tier_id,
      stripe_checkout_session_id: stripe_checkout_session_id
    })
    |> Repo.insert!()
  end
end
