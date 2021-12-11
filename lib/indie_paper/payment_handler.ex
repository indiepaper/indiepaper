defmodule IndiePaper.PaymentHandler do
  alias IndiePaper.{Authors, Books, Orders, Orders.OrderNotifier}
  alias IndiePaper.PaymentHandler.{StripeHandler, MoneyHandler}
  alias IndiePaper.MembershipTiers

  def get_stripe_connect_url(%Authors.Author{stripe_connect_id: nil} = author, country_code) do
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

  def get_subscription_checkout_session(
        %Authors.Author{id: reader_id, stripe_customer_id: stripe_customer_id},
        %Authors.Author{stripe_connect_id: stripe_connect_id} = author,
        %MembershipTiers.MembershipTier{id: membership_tier_id, stripe_price_id: stripe_price_id}
      ) do
    case StripeHandler.get_subscription_checkout_session(
           author: author,
           customer_id: stripe_customer_id,
           price_id: stripe_price_id,
           connect_id: stripe_connect_id,
           application_fee_percent: get_platform_percentage(),
           metadata: %{
             reader_id: reader_id,
             membership_tier_id: membership_tier_id
           }
         ) do
      {:ok, stripe_checkout_session} ->
        {:ok, stripe_checkout_session}

      {:error, error} ->
        {:error,
         error_message(error, "There was an error contacting Stripe. Please try again later.")}
    end
  end

  def get_checkout_session_url(customer, book) do
    book_with_products = Books.with_assoc(book, :products)
    read_online_product = Books.get_read_online_product(book)
    author = Books.get_author(book)

    order_amount =
      Enum.reduce(book_with_products.products, Money.new(0), fn product, acc ->
        MoneyHandler.add(product.price, acc)
      end)

    with {:ok, stripe_checkout_session} <-
           StripeHandler.get_checkout_session(
             item_title: "#{book.title} - #{read_online_product.title}",
             item_amount: read_online_product.price.amount,
             platform_fees: get_platform_fees(read_online_product.price).amount,
             stripe_connect_id: author.stripe_connect_id
           ),
         {:ok, _order} <-
           Orders.create_order(customer, %{
             amount: order_amount,
             book_id: book.id,
             stripe_checkout_session_id: stripe_checkout_session.id,
             products: book_with_products.products
           }) do
      {:ok, stripe_checkout_session.url}
    end
  end

  def set_payment_completed_order(stripe_checkout_session_id: stripe_checkout_session_id) do
    with order <- Orders.get_by_stripe_checkout_session_id!(stripe_checkout_session_id),
         {:ok, updated_order} <-
           Orders.set_payment_completed(order),
         order_with_books <- Orders.with_assoc(updated_order, [:customer, book: :author]),
         {:ok, _email} <-
           OrderNotifier.deliver_order_payment_completed_email(
             reader: order_with_books.customer,
             author: order_with_books.book.author,
             book: order_with_books.book
           ) do
      {:ok, updated_order}
    end
  end

  def create_product_with_price(author, membership_tier) do
    with {:ok, product} <-
           StripeHandler.create_product(
             name: "#{Authors.get_full_name(author)} as #{membership_tier.title}"
           ),
         {:ok, price} <-
           StripeHandler.create_price(
             product_id: product.id,
             unit_amount: membership_tier.amount.amount
           ) do
      {:ok, %{stripe_product_id: product.id, stripe_price_id: price.id}}
    else
      {:error, _} ->
        {:error, "There was an error communicating with Stripe. Please try again later."}
    end
  end

  def create_customer(%Authors.Author{stripe_customer_id: nil, email: email}) do
    case StripeHandler.create_customer(email) do
      {:ok, customer} ->
        {:ok, customer}

      {:error, error} ->
        {:error, error_message(error, "There was an error while creating Stripe Customer.")}
    end
  end

  def get_platform_percentage(), do: 9

  def get_platform_fees(price) do
    MoneyHandler.calculate_percentage(price, get_platform_percentage())
  end

  defp error_message(error, default_message) do
    (error.user_message && error.user_message) || default_message
  end
end
