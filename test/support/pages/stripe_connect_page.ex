defmodule IndiePaperWeb.Pages.StripeConnectPage.New do
  use IndiePaperWeb.PageHelpers

  def visit_page(session) do
    session
    |> visit(Routes.profile_stripe_connect_path(@endpoint, :new))
  end

  def select_country(session, country_code: country_code) do
    session
    |> fill_in(select("Country"), with: country_code)
  end

  def connect_stripe(session) do
    session
    |> click(button("Connect Stripe"))
  end

  def continue_stripe_connect(session) do
    session
    |> click(button("Continue Stripe Connect"))
  end

  def reset_stripe_connect(session) do
    session
    |> click(link("Reset Stripe"))
  end
end
