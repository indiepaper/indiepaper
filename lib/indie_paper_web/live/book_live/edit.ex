defmodule IndiePaperWeb.BookLive.Edit do
  use IndiePaperWeb, :live_view

  import IndiePaperWeb.UploadHelpers

  alias IndiePaper.Books
  alias IndiePaper.Authors
  alias IndiePaper.ExternalAssetHandler

  @impl Phoenix.LiveView
  def mount(%{"id" => book_id}, %{"author_token" => author_token}, socket) do
    current_author = Authors.get_author_by_session_token(author_token)
    book = Books.get_book!(book_id) |> Books.with_assoc(:draft)
    changeset = Books.change_book(book)

    {:ok,
     socket
     |> assign(:current_author, current_author)
     |> assign(:book, book)
     |> assign(:changeset, changeset)
     |> assign(:promo_images, book.promo_images)
     |> allow_upload(:promo_image,
       accept: ~w(.png .jpeg .jpg),
       max_entries: 1,
       external: &presign_upload/2
     )}
  end

  defp file_key(book, entry) do
    "public/promo_images/#{book.id}/#{entry.uuid}.#{file_ext(entry)}"
  end

  defp presign_upload(entry, socket) do
    book = socket.assigns.book

    {:ok, url, fields} =
      ExternalAssetHandler.presigned_post(
        key: file_key(book, entry),
        content_type: entry.client_type,
        max_file_size: socket.assigns.uploads.promo_image.max_file_size
      )

    meta = %{uploader: "S3", key: file_key(book, entry), url: url, fields: fields}
    {:ok, meta, socket}
  end

  defp put_promo_images(socket, book, params) do
    {completed, []} = uploaded_entries(socket, :promo_image)

    urls =
      for entry <- completed do
        file_key(book, entry)
      end

    Map.put(params, "promo_images", urls ++ socket.assigns.promo_images)
  end

  @impl Phoenix.LiveView
  def handle_event("remove-promo-image", %{"promo-image" => promo_image}, socket) do
    promo_images = Enum.reject(socket.assigns.promo_images, fn p -> p === promo_image end)
    {:noreply, socket |> assign(:promo_images, promo_images)}
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
    book_params_with_promo_images = put_promo_images(socket, socket.assigns.book, book_params)

    deleted_promo_images =
      Enum.reject(socket.assigns.book.promo_images, fn p ->
        Enum.member?(socket.assigns.promo_images, p)
      end)

    with {:ok, _} <- ExternalAssetHandler.delete_assets(deleted_promo_images),
         {:ok, updated_book} <-
           Books.update_book(
             socket.assigns.current_author,
             socket.assigns.book,
             book_params_with_promo_images
           ) do
      updated_book_with_draft = Books.with_assoc(updated_book, :draft)

      socket =
        socket
        |> put_flash(:info, "Listing page of book updated successfully.")
        |> redirect(
          to:
            if(Books.is_published?(updated_book),
              do: Routes.book_show_path(socket, :show, updated_book),
              else: Routes.draft_path(socket, :edit, updated_book_with_draft.draft)
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
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :promo_image, ref)}
  end
end
