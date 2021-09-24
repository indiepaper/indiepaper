defmodule IndiePaperWeb.StripeWebhookHandler do
  @behaviour Stripe.WebhookHandler
  @impl true
  def handle_event(%Stripe.Event{type: "checkout.session.completed"} = event) do
    {:ok, event}
  end

  @impl true
  def handle_event(_event), do: :ok
end
