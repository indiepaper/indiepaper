defmodule IndiePaperWeb.AuthorAuthLive do
  import Phoenix.LiveView

  alias IndiePaper.Authors
  alias IndiePaperWeb.Router.Helpers, as: Routes

  def on_mount(:default, _, %{"author_token" => author_token}, socket) do
    socket = assign_current_author(socket, author_token)

    if socket.assigns.current_author do
      {:cont, socket}
    else
      {:halt,
       socket
       |> put_flash(:info, "Create an account or Sign in to continue.")
       |> redirect(to: Routes.author_registration_path(socket, :new, return_to: "/hello"))}
    end
  end

  def on_mount(:fetch_current_author, _, %{"author_token" => author_token}, socket) do
    socket = assign_current_author(socket, author_token)
    {:cont, socket}
  end

  def on_mount(:fetch_current_author, _, _, socket) do
    {:cont, socket |> assign(current_author: nil)}
  end

  def on_mount(
        :require_account_status_confirmed,
        _,
        _,
        socket
      ) do
    if Authors.is_confirmed?(socket.assigns.current_author) do
      {:cont, socket}
    else
      {:halt,
       socket
       |> put_flash(
         :info,
         "Confirm your account to continue."
       )
       |> redirect(to: Routes.dashboard_path(socket, :index))}
    end
  end

  def on_mount(
        :require_account_status_payment_connected,
        _,
        _,
        socket
      ) do
    if Authors.is_payment_connected?(socket.assigns.current_author) do
      {:cont, socket}
    else
      {:halt,
       socket
       |> put_flash(
         :info,
         "Connect with your Stripe Account to Publish and start recieving payments"
       )
       |> redirect(to: Routes.profile_stripe_connect_path(socket, :new))}
    end
  end

  defp assign_current_author(socket, author_token) do
    assign_new(socket, :current_author, fn ->
      Authors.get_author_by_session_token(author_token)
    end)
  end
end
