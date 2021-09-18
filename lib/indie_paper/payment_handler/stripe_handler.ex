defmodule IndiePaper.PaymentHandler.StripeHandler do
  alias IndiePaperWeb.Endpoint

  def stripe_connect_enabled_countries() do
    [{"United States", "US"}, {"Italy", "IT"}, {"India", "IN"}]
  end

  def create_connect_account(country_code) do
    account_create_params = %{
      type: "express",
      country: country_code,
      capabilities: %{
        transfers: %{
          requested: true
        }
      }
    }

    account_create_params_with_tos =
      case country_code do
        "US" ->
          account_create_params

        _ ->
          account_create_params
          |> Map.put(
            :tos_acceptance,
            %{
              service_agreement: "recipient"
            }
          )
      end

    case Stripe.Account.create(account_create_params_with_tos) do
      {:ok, stripe_connect_account} -> {:ok, stripe_connect_account.id}
      {:error, _} -> {:error, "error creating Stripe connect account"}
    end
  end

  def get_connect_url(stripe_connect_id) do
    case Stripe.AccountLink.create(%{
           account: stripe_connect_id,
           refresh_url: "#{Endpoint.url()}/dashboard/stripe/connect",
           return_url: "#{Endpoint.url()}/dashboard",
           type: "account_onboarding"
         }) do
      {:ok, stripe_account_link} -> {:ok, stripe_account_link.url}
      {:error, _} -> {:error, "error creating Stripe Account link"}
    end
  end
end
