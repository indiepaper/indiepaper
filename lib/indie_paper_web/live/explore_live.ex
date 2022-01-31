defmodule IndiePaperWeb.ExploreLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Authors

  def mount(_, _, socket) do
    published_books = Books.list_published_books()
    {:ok, socket |> assign(books: published_books)}
  end
end
