defmodule IndiePaperWeb.DashboardLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books

  @impl true
  def mount(_params, _session, socket) do
    books =
      Books.list_books(socket.assigns.current_author) |> Books.with_assoc([:draft, :products])

    {:ok, assign(socket, books: books, page_title: "Dashboard")}
  end
end
