defmodule IndiePaper.PaymentHandler do
  alias IndiePaper.Authors
  alias IndiePaper.Books
  alias IndiePaper.Orders
  alias IndiePaper.Orders.OrderNotifier
  alias IndiePaper.PaymentHandler.MoneyHandler
  alias IndiePaper.PaymentHandler.StripeHandler

  def get_stripe_connect_url(%Authors.Author{id: author_id, stripe_connect_id: nil}, country_code) do
    author = Authors.get_author!(author_id)

    with {:ok, stripe_connect_id} <- StripeHandler.create_connect_account(country_code),
         {:ok, author_with_stripe_connect_id} <-
           Authors.set_stripe_connect_id(author, stripe_connect_id) do
      get_stripe_connect_url(author_with_stripe_connect_id, country_code)
    else
      {:error, _} ->
        {:error, "There was an error creating Stripe Account Setup. Try again later."}
    end
  end

  def get_stripe_connect_url(%Authors.Author{stripe_connect_id: stripe_connect_id}, _country_code) do
    case StripeHandler.get_connect_account_link(stripe_connect_id) do
      {:ok, stripe_connect_account_link} ->
        {:ok, stripe_connect_account_link.url}

      {:error, error} ->
        {:error,
         error_message(error, "There was an error creating Stripe Account. Try again later.")}
    end
  end

  def set_payment_connected(stripe_connect_id) do
    author = Authors.get_by_stripe_connect_id!(stripe_connect_id)
    Authors.set_payment_connected(author)
  end

  def get_checkout_session_url(reader, book, product) do
    author = Books.get_author(book)

    with {:ok, stripe_checkout_session} <-
           StripeHandler.get_checkout_session(
             item_title: "#{book.title} - #{product.title}",
             item_amount: product.price.amount,
             platform_fees: get_platform_fees(product.price).amount,
             stripe_connect_id: author.stripe_connect_id
           ),
         {:ok, _order} <-
           Orders.create_order(reader, %{
             amount: product.price.amount,
             book_id: book.id,
             stripe_checkout_session_id: stripe_checkout_session.id,
             products: [product]
           }) do
      {:ok, stripe_checkout_session.url}
    end
  end

  def set_payment_completed_order(stripe_checkout_session_id: stripe_checkout_session_id) do
    with order <- Orders.get_by_stripe_checkout_session_id!(stripe_checkout_session_id),
         {:ok, updated_order} <-
           Orders.set_payment_completed(order),
         order_with_books <- Orders.with_assoc(updated_order, [:reader, book: :author]),
         {:ok, _email} <-
           OrderNotifier.deliver_order_payment_completed_email(
             reader: order_with_books.reader,
             author: order_with_books.book.author,
             book: order_with_books.book
           ) do
      {:ok, updated_order}
    end
  end

  def create_reader(%Authors.Author{stripe_customer_id: nil, email: email}) do
    case StripeHandler.create_reader(email) do
      {:ok, reader} ->
        {:ok, reader}

      {:error, error} ->
        {:error, error_message(error, "There was an error while creating Stripe Reader.")}
    end
  end

  def get_platform_percentage(), do: 7

  def get_platform_fees(price) do
    MoneyHandler.calculate_percentage(price, get_platform_percentage())
  end

  defp error_message(error, default_message) do
    (error.user_message && error.user_message) || default_message
  end
end
