defmodule IndiePaperWeb.DashboardSubscriptionsLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth

  alias IndiePaper.Subscriptions
  alias IndiePaper.Books
  alias IndiePaper.BookLibrary

  @impl true
  def mount(_, _, socket) do
    subscriptions = Subscriptions.list_subscriptions(socket.assigns.current_author)

    {:ok,
     socket
     |> assign(
       page_title: "Subscriptions",
       subscriptions: subscriptions
     )}
  end
end
