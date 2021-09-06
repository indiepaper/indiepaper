defmodule IndiePaperWeb.StripeWebhookController do
  use IndiePaperWeb, :controller

  alias IndiePaper.PaymentHandler

  def connect(%Plug.Conn{assigns: %{stripe_event: stripe_event}} = conn, _params) do
    case handle_webhook(stripe_event) do
      {:ok, _} -> handle_success(conn)
      {:error, error} -> handle_error(conn, error)
      _ -> handle_error(conn, "error")
    end
  end

  defp handle_success(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok")
  end

  defp handle_error(conn, error) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(422, error)
  end

  def handle_webhook(%{
        type: "account.updated",
        data: %{object: %{charges_enabled: true, id: stripe_connect_id}}
      }) do
    case PaymentHandler.set_payment_connected(stripe_connect_id) do
      {:ok, _author} -> {:ok, "success"}
      {:error, _} -> {:error, "there was an error while setting payment connected"}
    end
  end

  def handle_webhook(%{type: "account.updated"}) do
    {:ok, "success"}
  end
end
