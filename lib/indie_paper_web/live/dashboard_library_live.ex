defmodule IndiePaperWeb.DashboardLibraryLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.BookLibrary
  alias IndiePaper.Authors

  @impl true
  def mount(_, %{"author_token" => author_token}, socket) do
    current_author = Authors.get_author_by_session_token(author_token)

    orders = BookLibrary.get_orders(current_author)
    {:ok, socket |> assign(current_author: current_author, orders: orders)}
  end
end
