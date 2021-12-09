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

    test "creates new stripe customer when stripe_customer_id is nil" do
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

  describe "list_subscriptions/1" do
    test "lists the subscriptions for the current reader" do
      [reader1, reader2] = insert_pair(:author)
      membership_tier = insert(:membership_tier)

      insert(:reader_author_subscription,
        reader: reader1,
        membership_tier: membership_tier
      )

      subscriptions = Subscriptions.list_subscriptions(reader1)

      assert Enum.find(subscriptions, fn s -> s.reader_id == reader1.id end)
      refute Enum.find(subscriptions, fn s -> s.reader_id == reader2.id end)
    end
  end
end
