defmodule IndiePaperWeb.ReadLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Authors
  alias IndiePaper.BookLibrary
  alias IndiePaper.Chapters
  alias IndiePaper.Products
  alias IndiePaper.ChapterProducts

  on_mount {IndiePaperWeb.AuthorAuthLive, :fetch_current_author}

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
       page_title: "Reading, #{book.title}"
     )}
  end

  @impl true
  def handle_params(%{"book_slug" => _book_slug, "chapter_id" => chapter_id}, _uri, socket) do
    selected_chapter = Chapters.get_chapter!(chapter_id)

    cond do
      Books.is_vanilla_book?(socket.assigns.book) ->
        if BookLibrary.has_purchased_read_online_asset?(
             socket.assigns.current_author,
             socket.assigns.book
           ) do
          {:noreply, assign(socket, selected_chapter: selected_chapter, not_pre_ordered: false)}
        else
          {:noreply, assign(socket, selected_chapter: selected_chapter, not_pre_ordered: true)}
        end

      Chapters.is_free?(selected_chapter) ->
        {:noreply, assign(socket, selected_chapter: selected_chapter, not_pre_ordered: false)}

      is_nil(socket.assigns.current_author) ->
        {:noreply, assign(socket, selected_chapter: selected_chapter, not_pre_ordered: true)}

      Authors.is_same?(socket.assigns.current_author, socket.assigns.book.author) ->
        {:noreply, assign(socket, selected_chapter: selected_chapter, not_pre_ordered: false)}

      true ->
        chapter_products = ChapterProducts.list_chapter_products(selected_chapter)
        chapter_product = List.first(chapter_products)
        product = Products.get_product!(chapter_product.product_id)

        if BookLibrary.has_purchased_product?(socket.assigns.current_author, product) do
          {:noreply, assign(socket, selected_chapter: selected_chapter, not_pre_ordered: false)}
        else
          {:noreply, assign(socket, selected_chapter: selected_chapter, not_pre_ordered: true)}
        end
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
