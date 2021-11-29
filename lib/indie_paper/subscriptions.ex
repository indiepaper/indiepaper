defmodule IndiePaper.Subscriptions do
  alias IndiePaper.PaymentHandler
  alias IndiePaper.Authors
  alias IndiePaper.MembershipTiers

  def create_subscription(
        %Authors.Author{id: author_id},
        %MembershipTiers.MembershipTier{author_id: author_id}
      ),
      do: {:error, "You cannot Subscribe to yourself. Share this page with your readers."}

  def create_subscription(
        %Authors.Author{} = reader,
        %MembershipTiers.MembershipTier{author_id: author_id} = membership_tier
      ) do
    author = Authors.get_author!(author_id)

    case PaymentHandler.get_subscription_checkout_session(reader, author, membership_tier) do
      {:ok, stripe_checkout_session} ->
        {:ok, stripe_checkout_session.url}

      result ->
        result
    end
  end
end
