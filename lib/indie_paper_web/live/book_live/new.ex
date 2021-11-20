defmodule IndiePaperWeb.BookLive.New do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books

  @impl true
  def mount(_, _session, socket) do
    changeset = Books.change_book(%Books.Book{})
    {:ok, assign(socket, changeset: changeset, form_submit_error: false)}
  end

  @impl true
  def handle_event("create_book", %{"book" => book_params}, socket) do
    {:ok, book} = Books.create_book_with_draft(socket.assigns.current_author, book_params)
    book_with_draft = Books.with_assoc(book, :draft)

    {:noreply, socket |> redirect(to: Routes.draft_path(socket, :edit, book_with_draft.draft))}
  end
end
