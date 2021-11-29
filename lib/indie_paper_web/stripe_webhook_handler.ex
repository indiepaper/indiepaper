defmodule IndiePaperWeb.StripeWebhookHandler do
  @behaviour Stripe.WebhookHandler

  alias IndiePaper.PaymentHandler
  alias IndiePaper.ReaderAuthorSubscriptions

  @impl true
  def handle_event(
        %Stripe.Event{
          type: "checkout.session.completed",
          data: %{
            object: %{
              id: stripe_checkout_session_id,
              mode: "subscription",
              metadata: %{"reader_id" => reader_id, "membership_tier_id" => membership_tier_id}
            }
          }
        } = event
      ) do
    ReaderAuthorSubscriptions.create_reader_author_subscription!(%{
      reader_id: reader_id,
      membership_tier_id: membership_tier_id,
      stripe_checkout_session_id: stripe_checkout_session_id,
      status: :active
    })

    {:ok, event}
  end

  @impl true
  def handle_event(
        %Stripe.Event{
          type: "checkout.session.completed",
          data: %{object: %{id: stripe_checkout_session_id}}
        } = event
      ) do
    case PaymentHandler.set_payment_completed_order(
           stripe_checkout_session_id: stripe_checkout_session_id
         ) do
      {:ok, _order} ->
        {:ok, event}
    end
  end

  @impl true
  def handle_event(_event), do: :ok
end
