defmodule IndiePaperWeb.DashboardLibraryLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.BookLibrary
  alias IndiePaper.Authors

  @impl true
  def mount(_, %{"author_token" => author_token}, socket) do
    current_author = Authors.get_author_by_session_token(author_token)

    orders = BookLibrary.list_payment_completed_orders(current_author)
    {:ok, socket |> assign(current_author: current_author, orders: orders)}
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
