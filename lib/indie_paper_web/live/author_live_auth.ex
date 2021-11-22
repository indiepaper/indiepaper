defmodule IndiePaperWeb.AuthorLiveAuth do
  import Phoenix.LiveView

  alias IndiePaper.Authors
  alias IndiePaperWeb.Router.Helpers, as: Routes

  def on_mount(:default, _, %{"author_token" => author_token}, socket) do
    socket = assign_current_author(socket, author_token)

    if socket.assigns.current_author do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: Routes.author_registration_path(socket, :new))}
    end
  end

  def on_mount(
        :require_account_status_payment_connected,
        _,
        %{"author_token" => author_token},
        socket
      ) do
    socket = assign_current_author(socket, author_token)

    if Authors.is_payment_connected?(socket.assigns.current_author) do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: Routes.author_registration_path(socket, :new))}
    end
  end

  defp assign_current_author(socket, author_token) do
    assign_new(socket, :current_author, fn ->
      Authors.get_author_by_session_token(author_token)
    end)
  end
end
