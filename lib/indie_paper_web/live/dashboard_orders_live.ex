defmodule IndiePaperWeb.DashboardOrdersLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Orders
  alias IndiePaper.Authors
  alias IndiePaper.ExternalAssetHandler
  alias IndiePaper.PaymentHandler.MoneyHandler

  on_mount IndiePaperWeb.AuthorAuthLive
  on_mount {IndiePaperWeb.AuthorAuthLive, :require_account_status_payment_connected}

  @impl true
  def mount(_, _, socket) do
    orders = Orders.list_orders_of_author(socket.assigns.current_author)

    {:ok, assign(socket, orders: orders, page_title: "Orders")}
  end
end
