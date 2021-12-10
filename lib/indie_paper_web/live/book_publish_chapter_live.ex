defmodule IndiePaperWeb.BookPublishChapterLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth
  on_mount {IndiePaperWeb.AuthorLiveAuth, :require_account_status_payment_connected}

  alias IndiePaper.Books
  alias IndiePaper.BookPublisher
  alias IndiePaper.Chapters
  alias IndiePaper.MembershipTiers
  alias IndiePaper.PaymentHandler.MoneyHandler

  @impl true
  def mount(%{"book_id" => book_id, "id" => chapter_id}, _, socket) do
    chapter = Chapters.get_chapter!(chapter_id)
    book = Books.get_book_with_draft!(book_id)
    author = Books.get_author(book)
    membership_tiers = MembershipTiers.list_membership_tiers(author)

    membership_tiers_with_free = [
      %MembershipTiers.MembershipTier{
        id: "free",
        title: "Free",
        description_html: "<p>Chapter can be read by anyone</p>",
        amount: MoneyHandler.new(0)
      }
      | membership_tiers
    ]

    {:ok,
     socket
     |> assign(
       chapter: chapter,
       membership_tiers: membership_tiers_with_free,
       book: book
     )}
  end

  @impl true
  def handle_event(
        "publish_chapter",
        %{"publish_chapter" => %{"membership_tiers" => membership_tiers_params}},
        socket
      ) do
    membership_tier_ids = String.split(membership_tiers_params, ",")

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
