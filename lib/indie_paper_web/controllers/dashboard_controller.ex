defmodule IndiePaperWeb.DashboardController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Books

  def index(%{assigns: %{current_author: current_author}} = conn, _params) do
    books = Books.list_books(current_author) |> Books.with_assoc([:draft, :products])
    render(conn, "index.html", books: books)
  end
end
