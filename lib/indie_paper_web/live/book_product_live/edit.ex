defmodule IndiePaperWeb.BookProductLive.Edit do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Products

  on_mount IndiePaperWeb.AuthorAuthLive
  on_mount {IndiePaperWeb.AuthorAuthLive, :require_account_status_payment_connected}

  @impl true
  def mount(%{"book_slug" => book_slug, "id" => product_id}, _session, socket) do
    book = Books.get_book_from_slug!(book_slug)
    product = Products.get_product!(product_id)

    with :ok <-
           Bodyguard.permit(Products, :update_product, socket.assigns.current_author, product) do
      {:ok,
       socket
       |> assign(book: book, product: product)}
    end
  end
end
