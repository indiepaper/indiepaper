defmodule IndiePaperWeb.BookEditLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Authors

  @impl Phoenix.LiveView
  def mount(%{"id" => book_id}, %{"author_token" => author_token}, socket) do
    current_author = Authors.get_author_by_session_token(author_token)
    book = Books.get_book!(book_id)
    changeset = Books.change_book(book)

    {:ok,
     socket
     |> assign(:current_author, current_author)
     |> assign(:book, book)
     |> assign(:changeset, changeset)
     |> allow_upload(:promo_image,
       accept: ~w(.png .jpeg .jpg),
       max_entries: 1,
       external: &presign_upload/2
     )}
  end

  defp presign_upload(entry, socket) do
    key = "public/promo_images/#{entry.uuid}"

    {:ok, url, fields} = IndiePaper.Services.S3Handler.generate_presigned_url(key)

    meta = %{uploader: "S3", key: key, url: url, fields: fields}
    {:ok, meta, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    IndiePaperWeb.BookView.render("edit.html", assigns)
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
    case Books.update_book(socket.assigns.current_author, socket.assigns.book, book_params) do
      {:ok, updated_book} ->
        socket =
          redirect(
            socket,
            to:
              if(Books.is_published?(updated_book),
                do: Routes.book_path(socket, :show, updated_book),
                else: Routes.dashboard_path(socket, :index)
              )
          )

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, socket |> assign(:changeset, changeset)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :promo_image, ref)}
  end
end
