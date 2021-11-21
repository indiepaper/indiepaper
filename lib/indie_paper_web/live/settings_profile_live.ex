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
    author_params_with_profile_picture =
      put_profile_picture(socket, socket.assigns.current_author, author_params)

    case AuthorProfile.update_profile(
           socket.assigns.current_author,
           author_params_with_profile_picture
         ) do
      {:ok, _author} ->
        {:noreply, socket |> redirect(to: Routes.dashboard_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset, form_error: true)}
    end
  end

  defp put_profile_picture(socket, author, params) do
    {completed, []} = uploaded_entries(socket, :profile_picture)
    entry = List.first(completed)

    Map.put(params, "profile_picture", profile_picture_key(author, entry))
  end

  defp profile_picture_key(author, entry) do
    "public/profile_pictures/#{author.id}/#{entry.uuid}.#{file_ext(entry)}"
  end
end
