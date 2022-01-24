defmodule IndiePaperWeb.BookLive.Edit do
  use IndiePaperWeb, :live_view

  import IndiePaperWeb.UploadHelpers

  alias IndiePaper.Books
  alias IndiePaper.Authors
  alias IndiePaper.ExternalAssetHandler
  alias IndiePaperWeb.UploadHelpers

  @impl Phoenix.LiveView
  def mount(%{"slug" => book_slug}, %{"author_token" => author_token}, socket) do
    current_author = Authors.get_author_by_session_token(author_token)
    book = Books.get_book_from_slug!(book_slug) |> Books.with_assoc(:draft)
    changeset = Books.change_book(book)

    {:ok,
     socket
     |> assign(:current_author, current_author)
     |> assign(:book, book)
     |> assign(:changeset, changeset)
     |> allow_upload(:cover_image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       external: &presign_cover_image_upload/2
     )}
  end

  def cover_image_file_key(book, entry),
    do: "public/cover_images/#{book.id}/cover_image.#{file_ext(entry)}"

  def presign_cover_image_upload(entry, socket) do
    book = socket.assigns.book

    {:ok, url, fields} =
      ExternalAssetHandler.presigned_post(
        key: cover_image_file_key(book, entry),
        content_type: entry.client_type,
        max_file_size: socket.assigns.uploads.cover_image.max_file_size
      )

    meta = %{uploader: "S3", key: cover_image_file_key(book, entry), url: url, fields: fields}
    {:ok, meta, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"book" => book_params}, socket) do
    changeset =
      socket.assigns.book
      |> Books.change_book(book_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("update_book_listing", %{"book" => book_params}, socket) do
    book_params_with_cover_image = maybe_put_cover_image(socket, socket.assigns.book, book_params)

    with {:ok, updated_book} <-
           Books.update_book(
             socket.assigns.current_author,
             socket.assigns.book,
             book_params_with_cover_image
           ),
         {:ok, _} <- maybe_remove_cover_image(socket.assigns.book, updated_book) do
      updated_book_with_draft = Books.with_assoc(updated_book, :draft)

      socket =
        socket
        |> put_flash(:info, "Listing page of book updated successfully.")
        |> push_redirect(
          to:
            if(Books.is_published?(updated_book),
              do: Routes.book_show_path(socket, :show, updated_book),
              else: Routes.draft_edit_path(socket, :edit, updated_book_with_draft.draft)
            )
        )

      {:noreply, socket}
    else
      {:error, changeset} ->
        {:noreply, socket |> assign(:changeset, changeset)}

      _ ->
        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-cover-image-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :cover_image, ref)}
  end

  defp maybe_remove_cover_image(
         %{cover_image: "public/cover_images/placeholder.png"},
         updated_book
       ),
       do: {:ok, updated_book}

  defp maybe_remove_cover_image(
         %{cover_image: cover_image},
         %{cover_image: cover_image} = updated_book
       ),
       do: {:ok, updated_book}

  defp maybe_remove_cover_image(
         %{cover_image: old_cover_image} = old_book,
         updated_book
       ) do
    case ExternalAssetHandler.delete_asset(old_cover_image) do
      {:ok, _} -> {:ok, updated_book}
      {:error, _} -> {:error, old_book}
    end
  end

  defp maybe_put_cover_image(socket, book, params) do
    {completed, []} = uploaded_entries(socket, :cover_image)
    entry = List.first(completed)

    if entry do
      Map.put(params, "cover_image", cover_image_file_key(book, entry))
    else
      params
    end
  end
end
