defmodule IndiePaperWeb.BookPublishChapterLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorAuthLive
  on_mount {IndiePaperWeb.AuthorAuthLive, :require_account_status_payment_connected}

  alias IndiePaper.Books
  alias IndiePaper.BookPublisher
  alias IndiePaper.Products
  alias IndiePaper.Chapters
  alias IndiePaper.ChapterProducts
  alias IndiePaper.PaymentHandler.MoneyHandler

  @impl true
  def mount(%{"book_slug" => book_slug, "id" => chapter_id}, _, socket) do
    chapter = Chapters.get_chapter!(chapter_id)
    chapter_products = ChapterProducts.list_chapter_products(chapter)
    book = Books.get_book_from_slug!(book_slug) |> Books.with_assoc([:draft, :products])

    free_product = %Products.Product{
      id: "free",
      title: "Free",
      description: "Chapter can be read by anyone",
      price: MoneyHandler.new(0)
    }

    selected_product =
      if Enum.empty?(chapter_products) do
        free_product
      else
        chapter_product = List.first(chapter_products)
        Products.get_product!(chapter_product.product_id)
      end

    products_with_free = [
      free_product
      | book.products
    ]

    {:ok,
     socket
     |> assign(
       chapter: chapter,
       products: products_with_free,
       book: book,
       selected_product: selected_product
     )}
  end

  @impl true
  def handle_event(
        "publish_chapter",
        %{"publish_chapter" => %{"products" => product_params}},
        socket
      ) do
    selected_product_id = parse_product_params(product_params)

    book =
      BookPublisher.publish_pre_order_chapter!(
        socket.assigns.book,
        socket.assigns.chapter,
        selected_product_id
      )

    {:noreply,
     socket
     |> redirect(
       to: Routes.book_read_path(socket, :index, book, chapter_id: socket.assigns.chapter)
     )}
  end

  defp parse_product_params("free"), do: nil
  defp parse_product_params(param) when is_binary(param), do: param
end
