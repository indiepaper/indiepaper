defmodule IndiePaperWeb.AuthorPageLive do
  use IndiePaperWeb, :live_view

  on_mount {IndiePaperWeb.AuthorLiveAuth, :fetch_current_author}

  alias IndiePaper.Authors
  alias IndiePaper.Books
  alias IndiePaper.MembershipTiers

  @impl true
  def mount(%{"username" => username}, _, socket) do
    case Authors.get_author_by_username(username) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "The Author was not found, check the profile url.")
         |> redirect(to: "/")}

      author ->
        published_books = Books.get_published_books(author)
        membership_tiers = MembershipTiers.list_membership_tiers(author)

        {:ok,
         socket
         |> assign(
           author: author,
           books: published_books,
           membership_tiers: membership_tiers
         )}
    end
  end
end
