defmodule IndiePaperWeb.ReadLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaperWeb.ReadView

  @impl true
  def render(assigns), do: ReadView.render("index.html", assigns)

  def mount(_session, socket), do: {:ok, socket}

  @impl true
  def handle_params(%{"book_id" => book_id}, _uri, socket) do
    book = Books.get_book!(book_id)
    {:noreply, assign(socket, book: book)}
  end
end
