defmodule IndiePaper.PaymentHandler.StripeHandler do
  alias IndiePaperWeb.Endpoint

  alias IndiePaperWeb.Router.Helpers, as: Routes

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
      },
      settings: %{
        payouts: %{
          schedule: %{
            interval: "weekly",
            delay_days: 7,
            weekly_anchor: "friday"
          }
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

  def get_connect_account_link(stripe_connect_id) do
    Stripe.AccountLink.create(%{
      account: stripe_connect_id,
      refresh_url: Routes.profile_stripe_connect_url(Endpoint, :new),
      return_url: Routes.dashboard_url(Endpoint, :index),
      type: "account_onboarding"
    })
  end

  def get_checkout_session(
        item_title: item_title,
        item_amount: item_amount,
        platform_fees: platform_fees,
        stripe_connect_id: stripe_connect_id
      ) do
    Stripe.Session.create(%{
      payment_method_types: ["card"],
      line_items: [
        %{
          name: item_title,
          amount: item_amount,
          currency: "usd",
          quantity: 1
        }
      ],
      payment_intent_data: %{
        application_fee_amount: platform_fees,
        transfer_data: %{
          destination: stripe_connect_id
        }
      },
      mode: "payment",
      success_url: Routes.dashboard_library_url(Endpoint, :index, stripe_checkout_success: true),
      cancel_url: Routes.dashboard_url(Endpoint, :index)
    })
  end

  def create_product(name: name) do
    Stripe.Product.create(%{
      name: name
    })
  end

  def create_price(product_id: product_id, unit_amount: unit_amount) do
    Stripe.Price.create(%{
      unit_amount: unit_amount,
      product: product_id,
      currency: "usd",
      recurring: %{
        interval: "month"
      }
    })
  end

  def create_customer(email) do
    Stripe.Customer.create(%{email: email})
  end
end
