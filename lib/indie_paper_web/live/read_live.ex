defmodule IndiePaperWeb.ReadLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.BookLibrary
  alias IndiePaper.Chapters

  on_mount IndiePaperWeb.AuthorLiveAuth

  @impl true
  def mount(%{"book_id" => book_id}, _session, socket) do
    book = Books.get_book!(book_id)
    published_chapters = Books.get_published_chapters(book)
    selected_chapter = List.first(published_chapters)

    {:ok,
     socket
     |> assign(
       book: book,
       published_chapters: published_chapters,
       selected_chapter: selected_chapter,
       book_added_to_library?:
         BookLibrary.book_added_to_library?(socket.assigns.current_author, book)
     )}
  end

  @impl true
  def handle_event("add_to_library", _, socket) do
    {:ok, _saved_book} =
      Books.add_serial_book_to_library(socket.assigns.current_author, socket.assigns.book)

    {:noreply,
     socket
     |> put_flash(
       :info,
       "The serial book has been added to your library. You will be notified when new chapters are published."
     )
     |> assign(book_added_to_library?: true)}
  end

  @impl true
  def handle_event("remove_from_library", _, socket) do
    Books.remove_serial_book_to_library!(socket.assigns.current_author, socket.assigns.book)

    {:noreply,
     socket
     |> put_flash(
       :info,
       "The book has been removed from your library, you will no longer be notified of new chapter releases."
     )
     |> assign(book_added_to_library?: false)}
  end

  @impl true
  def handle_event("select_chapter", %{"chapter_id" => chapter_id}, socket) do
    selected_chapter = Chapters.get_chapter!(chapter_id)
    {:noreply, socket |> assign(selected_chapter: selected_chapter)}
  end
end
