defmodule IndiePaperWeb.BookEditLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books

  @impl Phoenix.LiveView
  def mount(%{"id" => book_id}, _session, socket) do
    book = Books.get_book!(book_id)
    changeset = Books.change_book(book)

    {:ok,
     socket
     |> assign(:book, book)
     |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    IndiePaperWeb.BookView.render("edit.html", assigns)
  end
end
