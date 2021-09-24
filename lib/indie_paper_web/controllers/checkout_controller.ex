defmodule IndiePaperWeb.CheckoutController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{PaymentHandler, Books}

  def create(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id)
    {:ok, checkout_session_url} = PaymentHandler.get_checkout_session_url(book)

    redirect(conn, external: checkout_session_url)
  end
end