defmodule IndiePaperWeb.ReadController do
  use IndiePaperWeb, :controller

  action_fallback IndiePaperWeb.FallbackController

  alias IndiePaper.{Books, Chapters, Marketplace}

  def index(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id)
    published_chapters = Books.get_published_chapters(book)
    chapter = Enum.at(published_chapters, 0)

    render(conn, "show.html",
      book: book,
      chapters: published_chapters,
      current_chapter: chapter
    )
  end

  def show(conn, %{"book_id" => book_id, "id" => chapter_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:draft)

    published_chapters = Books.get_published_chapters(book)
    chapter = Chapters.get_chapter!(chapter_id)

    with :ok <- Bodyguard.permit(Marketplace, :can_read, conn.assigns.current_author, book) do
      render(conn, "show.html",
        book: book,
        chapters: published_chapters,
        current_chapter: chapter
      )
    end
  end
end
