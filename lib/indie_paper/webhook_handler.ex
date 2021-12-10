defmodule IndiePaper.WebhookHandler do
  alias IndiePaper.Authors
  alias IndiePaper.ReaderAuthorSubscriptions

  def subscription_checkout_session_completed(
        reader_id: reader_id,
        membership_tier_id: membership_tier_id,
        stripe_checkout_session_id: stripe_checkout_session_id,
        stripe_customer_id: stripe_customer_id
      ) do
    reader = Authors.get_author!(reader_id)

    case Authors.set_stripe_customer_id(reader, stripe_customer_id) do
      {:ok, _reader} ->
        reader_author_subscription =
          ReaderAuthorSubscriptions.create_reader_author_subscription!(%{
            reader_id: reader_id,
            membership_tier_id: membership_tier_id,
            stripe_checkout_session_id: stripe_checkout_session_id,
            status: :active
          })

        {:ok, reader_author_subscription}

      {:error, _} ->
        {:error, "There was an error while updating Stripe Customer ID"}
    end
  end
end
