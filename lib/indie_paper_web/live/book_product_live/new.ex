defmodule IndiePaperWeb.BookProductLive.New do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Products

  on_mount IndiePaperWeb.AuthorAuthLive
  on_mount {IndiePaperWeb.AuthorAuthLive, :require_account_status_payment_connected}

  @impl true
  def mount(%{"book_slug" => book_slug}, _session, socket) do
    book = Books.get_book_from_slug!(book_slug)
    product = Products.new_product()

    {:ok,
     socket
     |> assign(book: book, product: product)}
  end
end
