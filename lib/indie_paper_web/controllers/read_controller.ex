defmodule IndiePaperWeb.ReadController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{Books, Chapters}

  def index(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(draft: :chapters)
    chapter = Enum.at(book.draft.chapters, 0)

    redirect(conn, to: Routes.book_read_path(conn, :show, book, chapter))
  end

  def show(conn, %{"book_id" => book_id, "id" => chapter_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(draft: :chapters)
    chapter = Chapters.get_chapter!(chapter_id)

    render(conn, "show.html",
      book: book,
      chapters: book.draft.chapters,
      current_chapter: chapter
    )
  end
end
