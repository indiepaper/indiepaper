defmodule IndiePaperWeb.ReadLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Authors
  alias IndiePaper.BookLibrary
  alias IndiePaper.Chapters
  alias IndiePaper.ChapterProducts

  on_mount {IndiePaperWeb.AuthorLiveAuth, :fetch_current_author}

  @impl true
  def mount(%{"book_slug" => book_slug}, _session, socket) do
    book = Books.get_book_from_slug!(book_slug) |> Books.with_assoc([:author, :draft])
    published_chapters = Books.get_published_chapters(book)
    selected_chapter = List.first(published_chapters)

    {:ok,
     socket
     |> assign(
       book: book,
       published_chapters: published_chapters,
       selected_chapter: selected_chapter,
       not_pre_ordered: false,
       book_added_to_library?:
         BookLibrary.book_added_to_library?(socket.assigns.current_author, book)
     )}
  end

  @impl true
  def handle_event("add_to_library", _, socket) do
    case socket.assigns.current_author do
      nil ->
        {:noreply,
         socket
         |> put_flash(:info, "Sign up or Sign in to add this book to your Library.")
         |> redirect(
           to:
             Routes.author_registration_path(socket, :new,
               return_to: Routes.book_read_path(socket, :index, socket.assigns.book)
             )
         )}

      current_author ->
        {:ok, _saved_book} = Books.add_serial_book_to_library(current_author, socket.assigns.book)

        {:noreply,
         socket
         |> put_flash(
           :info,
           "The serial book has been added to your library. You will be notified when new chapters are published."
         )
         |> assign(book_added_to_library?: true)}
    end
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
  def handle_params(%{"book_slug" => _book_slug, "chapter_id" => chapter_id}, _uri, socket) do
    selected_chapter = Chapters.get_chapter!(chapter_id)

    if Chapters.is_free?(selected_chapter) do
      {:noreply, assign(socket, selected_chapter: selected_chapter, not_pre_ordered: false)}
    else
      chapter_products = ChapterProducts.list_chapter_products(selected_chapter)
      chapter_product = List.first(chapter_products)
      {:noreply, assign(socket, selected_chapter: selected_chapter, not_pre_ordered: true)}
    end
  end

  @impl true
  def handle_params(%{"book_slug" => _book_slugd}, _uri, socket) do
    {:noreply,
     socket
     |> push_patch(
       to:
         Routes.book_read_path(socket, :index, socket.assigns.book,
           chapter_id: socket.assigns.selected_chapter.id
         ),
       replace: true
     )}
  end
end
