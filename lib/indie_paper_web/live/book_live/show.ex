defmodule IndiePaperWeb.BookLive.Show do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books

  on_mount {IndiePaperWeb.AuthorLiveAuth, :fetch_current_author}

  def mount(%{"id" => book_id}, _session, socket) do
    book = Books.get_book!(book_id) |> Books.with_assoc([:author, :draft])
    {:ok, socket |> assign(book: book)}
  end
end
