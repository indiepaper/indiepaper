defmodule IndiePaperWeb.DashboardOrderController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Orders

  def index(%{assigns: %{current_author: customer}} = conn, _params) do
    orders =
      Orders.list_orders(customer) |> Orders.with_assoc([:book, [line_items: [product: :assets]]])

    render(conn, "index.html", orders: orders)
  end
end
