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
            interval: "daily",
            delay_days: 14
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

  def get_connect_url(stripe_connect_id) do
    case Stripe.AccountLink.create(%{
           account: stripe_connect_id,
           refresh_url: "#{Endpoint.url()}/dashboard/stripe/connect",
           return_url: "#{Endpoint.url()}/dashboard",
           type: "account_onboarding"
         }) do
      {:ok, stripe_account_link} -> {:ok, stripe_account_link.url}
      {:error, error} -> {:error, error}
    end
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

  def get_subscription_checkout_session(
        author: author,
        price_id: price_id,
        customer_id: customer_id
      ) do
    params = %{
      success_url: Routes.dashboard_library_url(Endpoint, :index, stripe_checkout_success: true),
      cancel_url: Routes.author_page_url(Endpoint, :show, author),
      mode: "subscription",
      line_items: [
        %{
          quantity: 1,
          price: price_id
        }
      ]
    }

    params =
      if customer_id do
        Map.put(params, :customer, customer_id)
      else
        params
      end

    Stripe.Session.create(params)
  end
end
