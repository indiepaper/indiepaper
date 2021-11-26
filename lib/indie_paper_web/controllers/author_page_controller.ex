defmodule IndiePaperWeb.AuthorPageController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Authors
  alias IndiePaper.Books
  alias IndiePaper.MembershipTiers

  def show(conn, %{"username" => username}) do
    case Authors.get_author_by_username(username) do
      nil ->
        conn |> put_status(404) |> halt()

      author ->
        published_books = Books.get_published_books(author)
        membership_tiers = MembershipTiers.list_membership_tiers(author)

        render(conn, "show.html",
          author: author,
          books: published_books,
          membership_tiers: membership_tiers
        )
    end
  end
end
