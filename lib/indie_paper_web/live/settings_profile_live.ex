defmodule IndiePaperWeb.SettingsProfileLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth

  alias IndiePaper.AuthorProfile

  @impl true
  def mount(_, _session, socket) do
    changeset = AuthorProfile.change_profile(socket.assigns.current_author)
    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("update_profile", %{"author" => author_params}, socket) do
    {:ok, _author} = AuthorProfile.update_profile(socket.assigns.current_author, author_params)
    {:noreply, socket |> redirect(to: Routes.dashboard_path(socket, :index))}
  end
end
