defmodule IndiePaper.PaymentHandler do
  alias IndiePaper.Authors
  alias IndiePaper.PaymentHandler.StripeHandler

  def get_stripe_connect_url(%Authors.Author{stripe_connect_id: nil} = author, country_code) do
    with {:ok, stripe_connect_id} <- StripeHandler.create_connect_account(country_code),
         {:ok, author_with_stripe_connect_id} <-
           Authors.update_author_profile(author, %{stripe_connect_id: stripe_connect_id}) do
      get_stripe_connect_url(author_with_stripe_connect_id, country_code)
    end
  end
end
