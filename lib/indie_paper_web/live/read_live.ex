defmodule IndiePaperWeb.ReadLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books

  on_mount IndiePaperWeb.AuthorLiveAuth

  @impl true
  def mount(%{"book_id" => book_id}, _session, socket) do
    book = Books.get_book!(book_id)

    {:ok, socket |> assign(book: book)}
  end
end
