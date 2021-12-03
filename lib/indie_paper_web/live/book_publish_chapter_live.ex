defmodule IndiePaperWeb.BookPublishChapterLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth
  on_mount {IndiePaperWeb.AuthorLiveAuth, :require_account_status_payment_connected}

  alias IndiePaper.Chapters
  alias IndiePaper.MembershipTiers
  alias IndiePaper.Books

  @impl true
  def mount(%{"book_id" => book_id, "id" => chapter_id}, _, socket) do
    chapter = Chapters.get_chapter!(chapter_id)
    book = Books.get_book!(book_id)
    author = Books.get_author(book)
    membership_tiers = MembershipTiers.list_membership_tiers(author)

    membership_tiers_with_free = [
      %MembershipTiers.MembershipTier{
        id: "free",
        title: "Free",
        description_html: "<p>Chapter can be read by anyone</p>"
      }
      | membership_tiers
    ]

    {:ok, socket |> assign(chapter: chapter, membership_tiers: membership_tiers_with_free)}
  end
end
