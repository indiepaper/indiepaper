defmodule IndiePaper.SubscriptionsTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Subscriptions

  describe "create_subscription/2" do
    test "returns error when buying own subscription" do
      reader = insert(:author)
      membership_tier = insert(:membership_tier, author: reader)

      {:error, message} = Subscriptions.create_subscription(reader, membership_tier)

      assert message =~ "cannot"
    end

    test "returns stripe checkout session url when customer_id is nil" do
      reader = insert(:author, stripe_customer_id: nil)
      membership_tier = insert(:membership_tier)

      {:ok, _stripe_checkout_session_url} =
        Subscriptions.create_subscription(reader, membership_tier)
    end
  end

  describe "is_subscribed?/2" do
    test "checks if reader is subscribed to author" do
      reader = insert(:author)
      membership_tier = insert(:membership_tier)

      insert(:reader_author_subscription,
        reader: reader,
        membership_tier: membership_tier
      )

      assert Subscriptions.is_subscribed?(reader, membership_tier.author)
      refute Subscriptions.is_subscribed?(membership_tier.author, reader)
    end
  end
end
