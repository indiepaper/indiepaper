defmodule IndiePaperWeb.DashboardLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Assets

  on_mount IndiePaperWeb.AuthorAuthLive

  @impl true
  def mount(_params, _session, socket) do
    books =
      Books.list_books(socket.assigns.current_author)
      |> Books.with_assoc([:draft, :products, :assets])

    {:ok, assign(socket, books: books, page_title: "Dashboard")}
  end

  @impl true
  def handle_event("goto_asset_url", %{"asset_id" => asset_id}, socket) do
    asset = Assets.get_asset!(asset_id)

    {:noreply, socket |> redirect(external: Assets.get_asset_url(asset))}
  end
end
