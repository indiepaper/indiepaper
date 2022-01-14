defmodule IndiePaperWeb.AuthorPageLive do
  use IndiePaperWeb, :live_view

  on_mount {IndiePaperWeb.AuthorAuthLive, :fetch_current_author}

  alias IndiePaper.Authors
  alias IndiePaper.Books

  @impl true
  def mount(%{"username" => username}, _, socket) do
    case Authors.get_author_by_username(username) do
      nil ->
        {:ok,
         socket
         |> put_flash(:info, "The Author was not found, check the profile url.")
         |> redirect(to: "/secure/sign-in")}

      author ->
        published_books = Books.get_published_books(author)

        {:ok,
         socket
         |> assign(
           author: author,
           books: published_books,
           page_title: IndiePaper.Authors.get_full_name(author)
         )}
    end
  end
end
