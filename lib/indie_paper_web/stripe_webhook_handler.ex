defmodule IndiePaperWeb.StripeWebhookHandler do
  @behaviour Stripe.WebhookHandler

  alias IndiePaper.PaymentHandler

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
