defmodule IndiePaperWeb.BookController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Books

  action_fallback IndiePaperWeb.FallbackController

  def new(conn, _params) do
    changeset = Books.change_book(%Books.Book{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_author: current_author}} = conn, %{"book" => book_params}) do
    case Books.create_book_with_draft(current_author, book_params) do
      {:ok, book} ->
        book_with_draft = Books.with_assoc(book, :draft)
        redirect(conn, to: Routes.draft_path(conn, :edit, book_with_draft.draft))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => book_id}) do
    book = Books.get_book!(book_id)
    changeset = Books.change_book(book)

    with :ok <- Bodyguard.permit(Books, :update_book, conn.assigns.current_author, book) do
      render(conn, "edit.html", book: book, changeset: changeset)
    end
  end

  def show(conn, %{"id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:author)
    render(conn, "show.html", book: book)
  end
end
