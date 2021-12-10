defmodule IndiePaperWeb.DashboardMembershipsLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth
  on_mount {IndiePaperWeb.AuthorLiveAuth, :require_account_status_payment_connected}

  alias IndiePaper.MembershipTiers

  @impl true
  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign(
       membership_tiers: MembershipTiers.list_membership_tiers(socket.assigns.current_author),
       page_title: "Memberships"
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Create Membership Tier")
    |> assign(:membership_tier, MembershipTiers.new_membership_tier())
  end

  defp apply_action(socket, :edit, %{"id" => membership_tier_id}) do
    socket
    |> assign(:page_title, "Edit Membership Tier")
    |> assign(:membership_tier, MembershipTiers.get_membership_tier!(membership_tier_id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:membership_tier, nil)
  end

  def is_membership_tiers_empty?(membership_tiers), do: Enum.empty?(membership_tiers)
end
