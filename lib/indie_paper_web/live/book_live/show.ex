defmodule IndiePaperWeb.BookLive.Show do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books

  on_mount {IndiePaperWeb.AuthorLiveAuth, :fetch_current_author}

  def mount(%{"slug" => book_slug}, _session, socket) do
    book = Books.get_book_from_slug!(book_slug) |> Books.with_assoc([:author, :draft])
    {:ok, socket |> assign(book: book)}
  end
end
