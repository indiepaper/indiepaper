defmodule IndiePaperWeb.DashboardMembershipsLive.FormComponent do
  use IndiePaperWeb, :live_component

  alias IndiePaper.MembershipTiers

  @impl true
  def update(%{membership_tier: membership_tier} = assigns, socket) do
    changeset = MembershipTiers.change_membership_tier(membership_tier)

    {:ok, assign(socket, assigns) |> assign(changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"membership_tier" => membership_tier_params}, socket) do
    changeset =
      socket.assigns.membership_tier
      |> MembershipTiers.change_membership_tier(membership_tier_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"membership_tier" => membership_tier_params}, socket) do
    save_membership_tier(socket, socket.assigns.action, membership_tier_params)
  end

  def save_membership_tier(socket, :new, membership_tier_params) do
    case MembershipTiers.create_membership_tier(
           socket.assigns.current_author,
           membership_tier_params
         ) do
      {:ok, _} ->
        {:noreply,
         put_flash(socket, :info, "New Membership tier created successfully.")
         |> push_redirect(to: Routes.dashboard_memberships_path(socket, :index))}

      {:error, :membership_tier, changeset, _} ->
        {:noreply, assign(socket, changeset: changeset)}

      {:error, _, _, _} ->
        {:noreply,
         put_flash(
           socket,
           :error,
           "There was an error creating the membership tier. Try again later."
         )
         |> push_redirect(to: Routes.dashboard_memberships_path(socket, :index))}
    end
  end

  def save_membership_tier(socket, :edit, membership_tier_params) do
    case MembershipTiers.update_membership_tier(
           socket.assigns.current_author,
           socket.assigns.membership_tier,
           membership_tier_params
         ) do
      {:ok, updated_tier} ->
        {:noreply,
         put_flash(socket, :info, "Membership tier #{updated_tier.title} updated successfully.")
         |> push_redirect(to: Routes.dashboard_memberships_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
