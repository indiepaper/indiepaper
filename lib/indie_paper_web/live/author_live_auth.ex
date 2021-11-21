defmodule IndiePaperWeb.AuthorLiveAuth do
  import Phoenix.LiveView

  alias IndiePaper.Authors
  alias IndiePaperWeb.Router.Helpers, as: Routes

  def on_mount(:default, _, %{"author_token" => author_token}, socket) do
    socket =
      assign_new(socket, :current_author, fn ->
        Authors.get_author_by_session_token(author_token)
      end)

    if socket.assigns.current_author do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: Routes.author_registration_path(socket, :new))}
    end
  end
end
