defmodule IndiePaper.PaymentHandler do
  alias IndiePaper.{Authors, Books, Orders}
  alias IndiePaper.PaymentHandler.StripeHandler

  def get_stripe_connect_url(%Authors.Author{stripe_connect_id: nil} = author, country_code) do
    with {:ok, stripe_connect_id} <- StripeHandler.create_connect_account(country_code),
         {:ok, author_with_stripe_connect_id} <-
           Authors.set_stripe_connect_id(author, stripe_connect_id) do
      get_stripe_connect_url(author_with_stripe_connect_id, country_code)
    else
      {:error, _} -> {:error, "error creating Stripe Connect account"}
    end
  end

  def get_stripe_connect_url(%Authors.Author{stripe_connect_id: stripe_connect_id}, _country_code) do
    StripeHandler.get_connect_url(stripe_connect_id)
  end

  def set_payment_connected(stripe_connect_id) do
    author = Authors.get_by_stripe_connect_id!(stripe_connect_id)
    Authors.set_payment_connected(author)
  end

  def get_checkout_session_url(customer, book) do
    read_online_product = Books.get_read_online_product(book)
    author = Books.get_author(book)

    with {:ok, stripe_checkout_session} <-
           StripeHandler.get_checkout_session(
             item_title: "#{book.title} - #{read_online_product.title}",
             item_amount: read_online_product.price.amount,
             stripe_connect_id: author.stripe_connect_id
           ),
         {:ok, _order} <- Orders.create_order(customer, book) do
      {:ok, stripe_checkout_session.url}
    end
  end
end
