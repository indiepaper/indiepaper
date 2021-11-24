defmodule IndiePaperWeb.DashboardMembershipsLive do
  use IndiePaperWeb, :live_view

  on_mount {IndiePaperWeb.AuthorLiveAuth, :require_account_status_payment_connected}

  @impl true
  def mount(_, _, socket) do
  end
end
