defmodule IndiePaperWeb.BookController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Drafts
  alias IndiePaper.Books

  def new(conn, %{"draft_id" => draft_id}) do
    draft = Drafts.get_draft!(draft_id)
    changeset = Books.change_book(%Books.Book{})
    render(conn, "new.html", draft: draft, changeset: changeset)
  end

  def create(conn, %{"draft_id" => draft_id, "book" => book_params}) do
    draft = Drafts.get_draft!(draft_id)
    {:ok, book} = Books.create_book(draft, book_params)

    redirect(conn, to: Routes.book_path(conn, :show, book))
  end

  def show(conn, %{"id" => book_id}) do
    book = Books.get_book!(book_id)
    render(conn, "show.html", book: book)
  end
end
