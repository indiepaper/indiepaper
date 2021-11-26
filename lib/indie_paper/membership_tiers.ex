defmodule IndiePaper.MembershipTiers do
  @behaviour Bodyguard.Policy

  def authorize(:update_membership_tier, %{id: author_id}, %{author_id: author_id}), do: true

  def authorize(_, _, _), do: false

  alias IndiePaper.Repo
  alias IndiePaper.PaymentHandler
  alias IndiePaper.MembershipTiers.MembershipTier

  def list_membership_tiers(author) do
    MembershipTier
    |> Bodyguard.scope(author)
    |> Repo.all()
  end

  def get_membership_tier!(id), do: Repo.get!(MembershipTier, id)

  def new_membership_tier(), do: %MembershipTier{}

  def change_membership_tier(membership_tier = %MembershipTier{}, attrs \\ %{}) do
    membership_tier
    |> MembershipTier.changeset(attrs)
  end

  def create_membership_tier_multi(current_author, params) do
    membership_tier_changeset =
      Ecto.build_assoc(current_author, :membership_tiers)
      |> MembershipTier.changeset(params)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:membership_tier, membership_tier_changeset)
    |> Ecto.Multi.run(:stripe_fields, fn _repo, %{membership_tier: membership_tier} ->
      PaymentHandler.create_product_with_price(current_author, membership_tier)
    end)
    |> Ecto.Multi.update(
      :membership_tier_with_stripe_fields,
      fn %{
           membership_tier: membership_tier,
           stripe_fields: stripe_fields
         } ->
        MembershipTier.stripe_fields_changeset(membership_tier, stripe_fields)
      end
    )
  end

  def create_membership_tier(current_author, params) do
    case create_membership_tier_multi(current_author, params) |> Repo.transaction() do
      {:ok, %{membership_tier_with_stripe_fields: membership_tier}} -> {:ok, membership_tier}
      {:error, :membership_tier, changeset, _} -> {:error, changeset}
      {:error, :stripe_fields, message, _} -> {:error, message}
    end
  end

  def update_membership_tier(current_author, membership_tier, params) do
    with :ok <-
           Bodyguard.permit!(__MODULE__, :update_membership_tier, current_author, membership_tier) do
      membership_tier
      |> MembershipTier.changeset(params)
      |> Repo.update()
    end
  end
end
