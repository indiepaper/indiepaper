defmodule IndiePaper.MembershipTiersTest do
  use IndiePaper.DataCase

  alias IndiePaper.MembershipTiers

  describe "list_membership_tiers/1" do
    test "lists the membership_tiers of the given author" do
      [membership_tier1, membership_tier2] = insert_pair(:membership_tier)

      memberships = MembershipTiers.list_membership_tiers(membership_tier1.author)

      assert Enum.find(memberships, fn membership -> membership.id == membership_tier1.id end)
      refute Enum.find(memberships, fn membership -> membership.id == membership_tier2.id end)
    end
  end

  describe "create_membership_tier/2" do
    test "creates new membership tier with stripe_product_id and stripe_price_id" do
      membership_tier_params =
        insert(:membership_tier, stripe_product_id: nil, stripe_price_id: nil)

      author = insert(:author)

      membership_tier = MembershipTiers.create_membership_tier(author, membership_tier_params)

      assert membership_tier.stripe_price_id
      assert membership_tier.stripe_product_id
    end
  end
end
