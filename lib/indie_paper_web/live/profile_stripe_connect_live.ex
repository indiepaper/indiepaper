defmodule IndiePaperWeb.ProfileStripeConnectLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.PaymentHandler

  on_mount IndiePaperWeb.AuthorLiveAuth
  on_mount {IndiePaperWeb.AuthorLiveAuth, :require_account_status_confirmed}

  @impl true
  def handle_event(
        "connect_stripe",
        %{"stripe_connect" => %{"country_code" => country_code}},
        socket
      ) do
    case PaymentHandler.get_stripe_connect_url(socket.assigns.current_author, country_code) do
      {:ok, stripe_connect_url} ->
        {:noreply, redirect(socket, external: stripe_connect_url)}

      {:error, message} ->
        IO.inspect(message)
        {:noreply, put_flash(socket, :alert, message)}
    end
  end
end
