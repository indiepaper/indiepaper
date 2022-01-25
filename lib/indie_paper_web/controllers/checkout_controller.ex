defmodule IndiePaperWeb.CheckoutController do
  use IndiePaperWeb, :controller

  alias IndiePaper.PaymentHandler
  alias IndiePaper.Books
  alias IndiePaper.Products

  def new(%{assigns: %{current_author: reader}} = conn, %{
        "book_slug" => book_slug,
        "product_id" => product_id
      }) do
    book = Books.get_book_from_slug!(book_slug) |> Books.with_assoc(:author)
    product = Products.get_product!(product_id)

    if book.author.id == reader.id do
      conn
      |> put_flash(
        :info,
        "Oops, you cannot buy your own book. Share this page with your readers, they will love to do so."
      )
      |> redirect(to: Routes.book_show_path(conn, :show, book))
    else
      {:ok, checkout_session_url} = PaymentHandler.get_checkout_session_url(reader, book, product)

      redirect(conn, external: checkout_session_url)
    end
  end
end
