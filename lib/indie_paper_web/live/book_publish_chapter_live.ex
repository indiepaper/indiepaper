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
    book = Books.get_book_from_slug!(book_slug) |> Books.with_assoc(:draft)
    product = Books.get_read_online_product(book)

    products_with_free = [
      %Products.Product{
        id: "free",
        title: "Free",
        description: "Chapter can be read by anyone",
        price: MoneyHandler.new(0)
      }
      | product
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
        %{"publish_chapter" => %{"products" => products_params}},
        socket
      ) do
    membership_tier_ids = String.split(products_params, ",")

    book =
      BookPublisher.publish_serial_chapter!(
        socket.assigns.book,
        socket.assigns.chapter,
        membership_tier_ids
      )

    {:noreply,
     socket
     |> redirect(
       to: Routes.book_read_path(socket, :index, book, chapter_id: socket.assigns.chapter)
     )}
  end
end
