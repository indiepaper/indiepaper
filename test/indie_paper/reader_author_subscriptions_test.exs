defmodule IndiePaper.ReaderAuthorSubscriptionsTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.ReaderAuthorSubscriptions

  describe "create_reader_author_subscription/2" do
    test "creates a new reader_author_subscription" do
      reader = insert(:author)
      author = insert(:author)
      membership_tier = insert(:membership_tier, author: author)

      reader_author_subscription =
        ReaderAuthorSubscriptions.create_reader_author_subscription!(%{
          reader_id: reader.id,
          author_id: author.id,
          membership_tier_id: membership_tier.id,
          stripe_checkout_session_id: "checkout_session_id"
        })

      assert reader_author_subscription.author_id == author.id
      assert reader_author_subscription.reader_id == reader.id
      assert reader_author_subscription.membership_tier_id == membership_tier.id
      assert reader_author_subscription.status == :inactive
      assert reader_author_subscription.stripe_checkout_session_id == "checkout_session_id"
    end
  end
end
