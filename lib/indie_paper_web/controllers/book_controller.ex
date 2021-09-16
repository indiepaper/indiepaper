defmodule IndiePaperWeb.BookController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Books

  def new(conn, _params) do
    changeset = Books.change_book(%Books.Book{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_author: current_author}} = conn, %{"book" => book_params}) do
    case Books.create_book_with_draft(current_author, book_params) do
      {:ok, book} ->
        book_with_draft = Books.with_draft(book)
        redirect(conn, to: Routes.draft_path(conn, :edit, book_with_draft.draft))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => book_id}) do
    book = Books.get_book!(book_id)
    changeset = Books.change_book(book)
    render(conn, "edit.html", book: book, changeset: changeset)
  end

  def update(conn, %{"id" => book_id, "book" => book_params}) do
    book = Books.get_book!(book_id)
    {:ok, updated_book} = Books.update_book(book, book_params)
    redirect(conn, to: Routes.book_path(conn, :show, updated_book))
  end

  def show(conn, %{"id" => book_id}) do
    book = Books.get_book!(book_id)
    render(conn, "show.html", book: book)
  end
end
