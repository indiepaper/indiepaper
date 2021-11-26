defmodule IndiePaperWeb.BookLive.New do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books

  on_mount IndiePaperWeb.AuthorLiveAuth

  @impl true
  def mount(_, _session, socket) do
    changeset = Books.change_book(%Books.Book{})

    {:ok,
     assign(socket, changeset: changeset, form_submit_error: false, page_title: "Create new book")}
  end

  @impl true
  def handle_event("create_book", %{"book" => book_params}, socket) do
    case Books.create_book(socket.assigns.current_author, book_params) do
      {:ok, book} ->
        book_with_draft = Books.with_assoc(book, :draft)

        {:noreply,
         socket |> redirect(to: Routes.draft_path(socket, :edit, book_with_draft.draft))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset, form_submit_error: true)}
    end
  end

  @impl true
  def handle_event("validate", %{"book" => book_params}, socket) do
    changeset =
      %Books.Book{}
      |> Books.change_book(book_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end
end
