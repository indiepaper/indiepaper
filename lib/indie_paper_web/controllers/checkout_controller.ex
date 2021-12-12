defmodule IndiePaperWeb.CheckoutController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{PaymentHandler, Books}

  def new(%{assigns: %{current_author: reader}} = conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:author)

    if book.author.id == reader.id do
      conn
      |> put_flash(
        :info,
        "Oops, you cannot buy your own book. Share this page with your readers, they will love to do so."
      )
      |> redirect(to: Routes.book_show_path(conn, :show, book))
    else
      {:ok, checkout_session_url} = PaymentHandler.get_checkout_session_url(reader, book)

      redirect(conn, external: checkout_session_url)
    end
  end
end
