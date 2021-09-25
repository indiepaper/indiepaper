defmodule IndiePaper.PaymentHandlerTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Orders
  alias IndiePaper.PaymentHandler

  describe "get_stripe_connect_url/2" do
    test "set stripe connect id and get stripe connect url" do
      author = insert(:author, stripe_connect_id: nil)

      {:ok, stripe_connect_url} = PaymentHandler.get_stripe_connect_url(author, "US")

      stripe_connect_uri = URI.parse(stripe_connect_url)

      assert String.contains?(stripe_connect_uri.host, "stripe.me")
    end
  end

  describe "set_payment_connected/1" do
    test "sets the payment connected to author who has the stripe connect id" do
      author = insert(:author, is_payment_connected: false)

      {:ok, updated_author} = PaymentHandler.set_payment_connected(author.stripe_connect_id)

      assert updated_author.stripe_connect_id == author.stripe_connect_id
      assert updated_author.is_payment_connected
    end
  end

  describe "get_checkout_session_url/1" do
    test "returns the stripe checkout session url" do
      book = insert(:book)
      customer = insert(:author)

      {:ok, checkout_session_url} = PaymentHandler.get_checkout_session_url(customer, book)

      assert checkout_session_url == nil
    end

    test "returns the stripe checkout session url even when customer is nil" do
      book = insert(:book)

      {:ok, checkout_session_url} = PaymentHandler.get_checkout_session_url(nil, book)

      assert checkout_session_url == nil
    end
  end

  describe "set_payment_completed_order/1" do
    test "sets the order status as payment connected" do
      order =
        insert(:order, status: :payment_pending, stripe_checkout_session_id: "checkout_session_id")

      {:ok, order} =
        PaymentHandler.set_payment_completed_order(
          stripe_checkout_session_id: order.stripe_checkout_session_id
        )

      assert Orders.is_payment_completed?(order)
    end
  end
end
