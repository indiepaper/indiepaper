defmodule IndiePaperWeb.ReadLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Authors
  alias IndiePaper.BookLibrary
  alias IndiePaper.Chapters
  alias IndiePaper.ChapterMembershipTiers
  alias IndiePaper.ReaderAuthorSubscriptions

  on_mount IndiePaperWeb.AuthorLiveAuth

  @impl true
  def mount(%{"book_id" => book_id}, _session, socket) do
    book = Books.get_book!(book_id) |> Books.with_assoc([:author, :draft])
    published_chapters = Books.get_published_chapters(book)
    selected_chapter = List.first(published_chapters)

    {:ok,
     socket
     |> assign(
       book: book,
       published_chapters: published_chapters,
       selected_chapter: selected_chapter,
       not_subscribed: false,
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
  def handle_params(%{"book_id" => _book_id, "chapter_id" => chapter_id}, _uri, socket) do
    selected_chapter = Chapters.get_chapter!(chapter_id)
    author = Books.get_author(socket.assigns.book)

    cond do
      Authors.is_same?(socket.assigns.current_author, author) ->
        {:noreply, assign(socket, selected_chapter: selected_chapter, not_subscribed: false)}

      Chapters.free?(selected_chapter) ->
        {:noreply, assign(socket, selected_chapter: selected_chapter, not_subscribed: false)}

      true ->
        membership_tiers = ChapterMembershipTiers.list_membership_tiers(selected_chapter.id)

        subscription =
          ReaderAuthorSubscriptions.get_subscription_by_reader_author_id(
            socket.assigns.current_author.id,
            author.id
          )

        if subscription &&
             Enum.any?(membership_tiers, fn membership_tier ->
               membership_tier.id === subscription.membership_tier.id
             end) do
          {:noreply, assign(socket, selected_chapter: selected_chapter, not_subscribed: false)}
        else
          chapter_with_masked_content =
            Map.merge(selected_chapter, %{
              content_json:
                Chapters.placeholder_content_json("Chapter", "lorem ipsum, kind of nice."),
              published_content_json:
                Chapters.placeholder_content_json("Chapter", "lorem ipsum, kind of nice.")
            })

          {:noreply,
           assign(socket, selected_chapter: chapter_with_masked_content, not_subscribed: true)}
        end
    end
  end

  @impl true
  def handle_params(%{"book_id" => _book_id}, _uri, socket) do
    {:noreply,
     socket
     |> push_patch(
       to:
         Routes.book_read_path(socket, :index, socket.assigns.book,
           chapter_id: socket.assigns.selected_chapter.id
         )
     )}
  end
end
