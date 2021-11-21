defmodule IndiePaperWeb.SettingsProfileLive do
  use IndiePaperWeb, :live_view

  import IndiePaperWeb.UploadHelpers

  alias IndiePaper.AuthorProfile

  @impl true
  def mount(_, _session, socket) do
    changeset = AuthorProfile.change_profile(socket.assigns.current_author)

    {:ok,
     assign(socket, changeset: changeset, form_error: false)
     |> allow_upload(:profile_picture, accept: ~w(.jpg .jpeg .png))}
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
    uploaded_files =
      consume_uploaded_entries(socket, :profile_picture, fn %{path: path}, _entry ->
        nil
      end)

    case AuthorProfile.update_profile(socket.assigns.current_author, author_params) do
      {:ok, _author} ->
        {:noreply, socket |> redirect(to: Routes.dashboard_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset, form_error: true)}
    end
  end
end
