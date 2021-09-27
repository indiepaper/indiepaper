defmodule IndiePaperWeb.Feature.AuthorCanConnectPaymentWithStripeTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{LoginPage, DashboardPage, StripeConnectPage}

  test "author can connect payment with Stripe", %{session: session} do
    author = insert(:author, is_payment_connected: false)

    stripe_url =
      session
      |> DashboardPage.visit_page()
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
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: author.email, password: author.password)
    |> DashboardPage.has_no_connect_stripe?()
    |> StripeConnectPage.New.visit_page()
    |> DashboardPage.has_confirm_email_text?()
  end
end
