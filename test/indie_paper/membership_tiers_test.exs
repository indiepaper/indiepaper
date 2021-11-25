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
end
