defmodule IndiePaperWeb.ProfileStripeConnectController do
  use IndiePaperWeb, :controller

  alias IndiePaper.PaymentHandler
  alias IndiePaper.Authors

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(%{assigns: %{current_author: current_author}} = conn, %{
        "stripe_connect_params" => %{"country_code" => country_code}
      }) do
    case PaymentHandler.get_stripe_connect_url(current_author, country_code) do
      {:ok, stripe_connect_url} ->
        conn
        |> redirect(external: stripe_connect_url)

      {:error, message} ->
        conn |> put_flash(:alert, message) |> render(conn, "new.html")
    end
  end

  def delete(%{assigns: %{current_author: current_author}} = conn, _params) do
    {:ok, _author} = Authors.set_stripe_connect_id(current_author, nil)
    redirect(conn, to: Routes.profile_stripe_connect_path(conn, :new))
  end
end
