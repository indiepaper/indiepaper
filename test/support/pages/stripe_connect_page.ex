defmodule IndiePaperWeb.Pages.StripeConnectPage.New do
  use IndiePaperWeb.PageHelpers

  def select_country(session, country_code: country_code) do
    session
    |> fill_in(select("Country"), with: country_code)
  end

  def connect_stripe(session) do
    session
    |> click(button("Connect Stripe"))
  end
end
