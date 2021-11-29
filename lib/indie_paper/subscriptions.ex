defmodule IndiePaper.Subscriptions do
  alias IndiePaper.Repo
  alias IndiePaper.PaymentHandler
  alias IndiePaper.Authors
  alias IndiePaper.MembershipTiers
  alias IndiePaper.ReaderAuthorSubscriptions

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

  def is_subscribed?(
        %Authors.Author{id: reader_id} = _reader,
        %Authors.Author{id: author_id} = _author
      ) do
    case ReaderAuthorSubscriptions.get_subscription_by_reader_author_id(reader_id, author_id) do
      nil -> false
      _subscription -> true
    end
  end

  def list_subscriptions(reader) do
    ReaderAuthorSubscriptions.list_subscriptions_of_reader(reader.id)
    |> Repo.preload(membership_tier: :author)
  end
end
