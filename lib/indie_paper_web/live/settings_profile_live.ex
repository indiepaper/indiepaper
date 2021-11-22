defmodule IndiePaperWeb.SettingsProfileLive do
  use IndiePaperWeb, :live_view

  import IndiePaperWeb.UploadHelpers

  alias IndiePaper.AuthorProfile
  alias IndiePaper.ExternalAssetHandler
  alias IndiePaper.ImageHandler

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
      maybe_put_profile_picture(socket, socket.assigns.current_author, author_params)

    with {:ok, updated_author} <-
           AuthorProfile.update_profile(
             socket.assigns.current_author,
             author_params_with_profile_picture
           ),
         {:ok, _} <- maybe_remove_profile_picture(socket.assigns.current_author, updated_author),
         {:ok, _author} <-
           consume_profile_picture(socket, updated_author) do
      {:noreply,
       socket
       |> put_flash(:info, "Profile updated successfully.")
       |> redirect(to: Routes.dashboard_path(socket, :index))}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset, form_error: true)}

      {:error, _} ->
        {:noreply,
         put_flash(
           socket,
           :error,
           "There was an errow while removing your old profile picture. Try again after some time."
         )}
    end
  end

  defp maybe_remove_profile_picture(
         %{profile_picture: "public/profile_pictures/placeholder.png"},
         updated_author
       ),
       do: {:ok, updated_author}

  defp maybe_remove_profile_picture(
         %{profile_picture: profile_picture},
         %{profile_picture: profile_picture} = updated_author
       ),
       do: {:ok, updated_author}

  defp maybe_remove_profile_picture(
         %{profile_picture: old_profile_picture} = old_author,
         updated_author
       ) do
    case ExternalAssetHandler.delete_asset(old_profile_picture) do
      {:ok, _} -> {:ok, updated_author}
      {:error, _} -> {:error, old_author}
    end
  end

  defp consume_profile_picture(socket, author) do
    consume_uploaded_entries(socket, :profile_picture, fn %{path: path}, entry ->
      image_file =
        ImageHandler.open(path)
        |> ImageHandler.resize_to_square(400)
        |> ImageHandler.save_in_place()
        |> ImageHandler.to_file!()

      {:ok, _} =
        ExternalAssetHandler.upload_file(
          author.profile_picture,
          image_file,
          entry.client_type,
          :public_read
        )
    end)

    {:ok, author}
  end

  defp maybe_put_profile_picture(socket, author, params) do
    {completed, []} = uploaded_entries(socket, :profile_picture)
    entry = List.first(completed)

    if entry do
      Map.put(params, "profile_picture", profile_picture_key(author, entry))
    else
      params
    end
  end

  defp profile_picture_key(author, entry) do
    "public/profile_pictures/#{author.id}/#{entry.uuid}.#{file_ext(entry)}"
  end
end
