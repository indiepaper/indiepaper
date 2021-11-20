defmodule IndiePaperWeb.SettingsProfileLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.AuthorProfile

  @impl true
  def mount(_, _session, socket) do
    changeset = AuthorProfile.change_profile(socket.assigns.current_author)

    {:ok,
     assign(socket, changeset: changeset, form_error: false)
     |> allow_upload(:profile_picture, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"author" => author_params}, socket) do
    changeset =
      AuthorProfile.change_profile(socket.assigns.current_author, author_params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("update_profile", %{"author" => author_params}, socket) do
    case AuthorProfile.update_profile(socket.assigns.current_author, author_params) do
      {:ok, _author} ->
        {:noreply, socket |> redirect(to: Routes.dashboard_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset, form_error: true)}
    end
  end
end
