defmodule IndiePaperWeb.StripeWebhookHandler do
  @behaviour Stripe.WebhookHandler

  alias IndiePaper.PaymentHandler
  alias IndiePaper.WebhookHandler

  @impl true
  def handle_event(
        %Stripe.Event{
          type: "account.updated",
          data: %{object: %{charges_enabled: true, id: stripe_connect_id}}
        } = event
      ) do
    case PaymentHandler.set_payment_connected(stripe_connect_id) do
      {:ok, _author} -> {:ok, event}
    end
  end

  @impl true
  def handle_event(
        %Stripe.Event{
          type: "checkout.session.completed",
          data: %{object: %{id: stripe_checkout_session_id}}
        } = event
      ) do
    case WebhookHandler.handle_checkout_session_completed(stripe_checkout_session_id) do
      {:ok, _} ->
        {:ok, event}
    end
  end

  @impl true
  def handle_event(_event), do: :ok
end
