defmodule IndiePaperWeb.DashboardMembershipsLive.FormComponent do
  use IndiePaperWeb, :live_component

  alias IndiePaper.MembershipTiers

  @impl true
  def update(%{membership_tier: membership_tier} = assigns, socket) do
    changeset = MembershipTiers.change_membership_tier(membership_tier)

    {:ok, assign(socket, assigns) |> assign(changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"membership_tier" => membership_tier_params}, socket) do
    {:ok, _membership_tier} =
      MembershipTiers.create_membership_tier(
        socket.assigns.current_author,
        membership_tier_params
      )

    {:noreply,
     put_flash(socket, :info, "Membership tier created successfully.")
     |> push_redirect(to: Routes.dashboard_memberships_path(socket, :index))}
  end

  @impl true
  def handle_event("validate", %{"membership_tier" => membership_tier_params}, socket) do
    changeset =
      socket.assigns.membership_tier
      |> MembershipTiers.change_membership_tier(membership_tier_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end
end
