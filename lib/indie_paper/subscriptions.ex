defmodule IndiePaper.Subscriptions do
  alias IndiePaper.PaymentHandler
  alias IndiePaper.Authors
  alias IndiePaper.MembershipTiers
  alias IndiePaper.ReaderAuthorSubscriptions

  def create_subscription(
        %Authors.Author{id: author_id},
        %MembershipTiers.MembershipTier{author_id: author_id}
      ),
      do: {:error, "You cannot Subscribe to yourself."}

  def create_subscription(
        %Authors.Author{} = reader,
        %MembershipTiers.MembershipTier{author_id: author_id} = membership_tier
      ) do
    author = Authors.get_author!(author_id)

    case PaymentHandler.get_subscription_checkout_session(reader, author, membership_tier) do
      {:ok, stripe_checkout_session} ->
        ReaderAuthorSubscriptions.create_reader_author_subscription!(
          reader: reader,
          membership_tier: membership_tier,
          stripe_checkout_session_id: stripe_checkout_session.id
        )

        {:ok, stripe_checkout_session.url}

      result ->
        result
    end
  end
end
