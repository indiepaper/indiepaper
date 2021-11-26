defmodule IndiePaper.MembershipTiers.MembershipTierTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.MembershipTiers.MembershipTier

  describe "changeset/2" do
    test "throws errors when amount is greater than $1000" do
      membership_tier_params = params_for(:membership_tier, amount: 100_000)

      changeset = MembershipTier.changeset(%MembershipTier{}, membership_tier_params)

      assert "must be less than $1000" in errors_on(changeset).amount
    end
  end
end
