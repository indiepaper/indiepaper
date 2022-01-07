defmodule IndiePaper.WebhookHandlerTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.WebhookHandler
  alias IndiePaper.Orders
  alias IndiePaper.ReaderBookSubscriptions

  describe "checkout_session_completed/1" do
    test "creates a reader book subscription" do
      order = insert(:order, status: :payment_pending)

      {:ok, updated_order} =
        WebhookHandler.handle_checkout_session_completed(order.stripe_checkout_session_id)

      assert Orders.is_payment_completed?(updated_order)
    end
  end
end
