defmodule IndiePaper.MembershipTiers do
  alias IndiePaper.Repo
  alias IndiePaper.MembershipTiers.MembershipTier

  def new_membership_tier(), do: %MembershipTier{}

  def change_membership_tier(membership_tier = %MembershipTier{}, attrs \\ %{}) do
    membership_tier
    |> MembershipTier.changeset(attrs)
  end

  def create_membership_tier(current_author, params) do
    Ecto.build_assoc(current_author, :membership_tiers)
    |> MembershipTier.changeset(params)
    |> Repo.insert()
  end
end
