defmodule IndiePaperWeb.Feature.AuthorCanConnectPaymentWithStripeTest do
  use IndiePaperWeb.FeatureCase, async: false

  alias IndiePaperWeb.Pages.{LoginPage, DashboardPage, StripeConnectPage}

  test "author can connect payment with Stripe", %{session: session} do
    author = insert(:author, is_payment_connected: false, stripe_connect_id: nil)

    stripe_url =
      session
      |> LoginPage.visit_page()
      |> LoginPage.login(email: author.email, password: author.password)
      |> DashboardPage.click_connect_stripe()
      |> StripeConnectPage.New.select_country(country_code: "US")
      |> StripeConnectPage.New.connect_stripe()
      |> current_url()

    stripe_uri = URI.parse(stripe_url)

    assert String.contains?(stripe_uri.host, "stripe.me")
  end

  test "redirected to dashboard when not confirmed", %{session: session} do
    author = insert(:author, is_payment_connected: false, account_status: :created)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: author.email, password: author.password)
    |> DashboardPage.has_no_connect_stripe?()
    |> StripeConnectPage.New.visit_page()
    |> DashboardPage.has_confirm_email_text?()
  end

  test "author can reconnect stripe", %{session: session} do
    author = insert(:author, is_payment_connected: false, account_status: :confirmed)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: author.email, password: author.password)
    |> DashboardPage.click_connect_stripe()
    |> StripeConnectPage.New.continue_stripe_connect()
  end

  test "author can reset connected stripe account", %{session: session} do
    author = insert(:author, is_payment_connected: false, account_status: :confirmed)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: author.email, password: author.password)
    |> DashboardPage.click_connect_stripe()
    |> StripeConnectPage.New.reset_stripe_connect()
    |> StripeConnectPage.New.connect_stripe()
  end
end
