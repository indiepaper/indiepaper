defmodule IndiePaper.WebhookHandler do
  alias IndiePaper.PaymentHandler

  def handle_checkout_session_completed(stripe_checkout_session_id) do
    PaymentHandler.set_payment_completed_order(
      stripe_checkout_session_id: stripe_checkout_session_id
    )
  end
end
