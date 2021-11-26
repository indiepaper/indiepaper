defmodule IndiePaperWeb.DashboardLibraryLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth

  alias IndiePaper.BookLibrary

  @impl true
  def mount(_, _, socket) do
    orders = BookLibrary.list_payment_completed_orders(socket.assigns.current_author)
    {:ok, socket |> assign(orders: orders, page_title: "Library")}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      if params["stripe_checkout_success"] do
        put_flash(
          socket,
          :info,
          "Hoorah! Your purchase has been succesfully completed. You can find the order here."
        )
      else
        socket
      end

    {:noreply, socket}
  end
end
