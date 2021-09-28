defmodule IndiePaperWeb.DashboardOrderController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Orders

  def index(%{assigns: %{current_author: customer}} = conn, params) do
    orders =
      Orders.list_orders(customer) |> Orders.with_assoc([:book, [line_items: [product: :assets]]])

    if(params["stripe_checkout_success"]) do
      conn
      |> put_flash(
        :info,
        "Hoorah!! Your purchase has been succesfully completed. You can find the order here."
      )
      |> render("index.html", orders: orders)
    else
      conn
      |> render("index.html", orders: orders)
    end
  end
end
