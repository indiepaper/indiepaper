defmodule IndiePaper.SubscriptionsTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Subscriptions

  describe "create_subscription/2" do
    test "returns stripe checkout session url when customer_id is nil" do
      reader = insert(:author, stripe_customer_id: nil)
      membership_tier = insert(:membership_tier)

      {:ok, _stripe_checkout_session_url} =
        Subscriptions.create_subscription(reader, membership_tier)
    end
  end
end
