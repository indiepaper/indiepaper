defmodule IndiePaperWeb.ProfileStripeConnectController do
  use IndiePaperWeb, :controller

  alias IndiePaper.PaymentHandler

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(%{assigns: %{current_author: current_author}} = conn, %{
        "stripe_connect_params" => %{"country_code" => country_code}
      }) do
    {:ok, stripe_connect_url} =
      PaymentHandler.get_stripe_connect_url(current_author, country_code)

    conn
    |> redirect(external: stripe_connect_url)
  end
end
