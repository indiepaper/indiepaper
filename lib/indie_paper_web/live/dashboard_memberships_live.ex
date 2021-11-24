defmodule IndiePaperWeb.DashboardMembershipsLive do
  use IndiePaperWeb, :live_view

  on_mount {IndiePaperWeb.AuthorLiveAuth, :require_account_status_payment_connected}

  alias IndiePaper.MembershipTiers

  @impl true
  def mount(_, _, socket) do
    {:ok, socket |> assign(page_title: "Memberships")}
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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:membership_tier, nil)
  end
end
