defmodule IndiePaper.WebhookHandlerTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.WebhookHandler
  alias IndiePaper.Authors

  describe "subscription_checkout_session_completed/2" do
    test "creates a new subscription and sets the stripe_customer_id of the reader" do
      reader = insert(:author)
      membership_tier = insert(:membership_tier)

      {:ok, reader_author_subscription} =
        WebhookHandler.subscription_checkout_session_completed(
          reader_id: reader.id,
          membership_tier_id: membership_tier.id,
          stripe_checkout_session_id: "checkout_session_id",
          stripe_customer_id: "customer_id"
        )

      updated_reader = Authors.get_author!(reader.id)

      assert reader_author_subscription.reader_id == reader.id
      assert reader_author_subscription.membership_tier_id == membership_tier.id
      assert updated_reader.stripe_customer_id == "customer_id"
    end
  end
end
