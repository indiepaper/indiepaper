defmodule IndiePaperWeb.SettingsProfileLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth

  alias IndiePaper.AuthorProfile

  @impl true
  def mount(_, _session, socket) do
    changeset = AuthorProfile.change_profile(socket.assigns.current_author)
    {:ok, assign(socket, changeset: changeset)}
  end
end
