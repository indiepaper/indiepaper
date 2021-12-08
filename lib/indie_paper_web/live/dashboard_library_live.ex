defmodule IndiePaperWeb.DashboardLibraryLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth

  alias IndiePaper.BookLibrary
  alias IndiePaper.Authors

  @impl true
  def mount(_, _, socket) do
    orders = BookLibrary.list_payment_completed_orders(socket.assigns.current_author)
    subscribed_books = BookLibrary.list_subscribed_books(socket.assigns.current_author)

    {:ok,
     socket
     |> assign(
       orders: orders,
       subscribed_books: subscribed_books,
       page_title: "Library"
     )}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      if params["stripe_checkout_success"] do
        put_flash(
          socket,
          :info,
          "Hoorah! Your checkout has been succesfully completed. You can find the purchase here."
        )
      else
        socket
      end

    {:noreply, socket}
  end
end
