defmodule IndiePaperWeb.BookPublishChapterLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth
  on_mount {IndiePaperWeb.AuthorLiveAuth, :require_account_status_payment_connected}

  alias IndiePaper.Books
  alias IndiePaper.BookPublisher
  alias IndiePaper.Products
  alias IndiePaper.Chapters
  alias IndiePaper.PaymentHandler.MoneyHandler

  @impl true
  def mount(%{"book_slug" => book_slug, "id" => chapter_id}, _, socket) do
    chapter = Chapters.get_chapter!(chapter_id)
    book = Books.get_book_from_slug!(book_slug) |> Books.with_assoc([:draft, :products])

    products_with_free = [
      %Products.Product{
        id: "free",
        title: "Free",
        description: "Chapter can be read by anyone",
        price: MoneyHandler.new(0)
      }
      | book.products
    ]

    {:ok,
     socket
     |> assign(
       chapter: chapter,
       products: products_with_free,
       book: book
     )}
  end

  @impl true
  def handle_event(
        "publish_chapter",
        %{"publish_chapter" => %{"products" => _products_params}},
        socket
      ) do
    book =
      BookPublisher.publish_pre_order_chapter!(
        socket.assigns.book,
        socket.assigns.chapter
      )

    {:noreply,
     socket
     |> redirect(
       to: Routes.book_read_path(socket, :index, book, chapter_id: socket.assigns.chapter)
     )}
  end
end
