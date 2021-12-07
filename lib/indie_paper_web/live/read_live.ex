defmodule IndiePaperWeb.ReadLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books

  on_mount IndiePaperWeb.AuthorLiveAuth

  @impl true
  def mount(%{"book_id" => book_id}, _session, socket) do
    book = Books.get_book!(book_id)
    published_chapters = Books.get_published_chapters(book)

    {:ok, socket |> assign(book: book, published_chapters: published_chapters)}
  end
end
