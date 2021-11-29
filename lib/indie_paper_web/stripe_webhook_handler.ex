defmodule IndiePaperWeb.StripeWebhookHandler do
  @behaviour Stripe.WebhookHandler

  alias IndiePaper.PaymentHandler
  alias IndiePaper.WebhookHandler

  @impl true
  def handle_event(
        %Stripe.Event{
          type: "checkout.session.completed",
          data: %{
            object: %{
              id: stripe_checkout_session_id,
              mode: "subscription",
              customer: stripe_customer_id,
              metadata: %{"reader_id" => reader_id, "membership_tier_id" => membership_tier_id}
            }
          }
        } = event
      ) do
    case WebhookHandler.subscription_checkout_session_completed(
           reader_id: reader_id,
           membership_tier_id: membership_tier_id,
           stripe_checkout_session_id: stripe_checkout_session_id,
           stripe_customer_id: stripe_customer_id
         ) do
      {:ok, _} ->
        {:ok, event}
    end
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
