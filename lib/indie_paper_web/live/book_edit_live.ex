defmodule IndiePaperWeb.BookEditLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Authors

  @impl Phoenix.LiveView
  def mount(%{"id" => book_id}, %{"author_token" => author_token}, socket) do
    current_author = Authors.get_author_by_session_token(author_token)
    book = Books.get_book!(book_id)
    changeset = Books.change_book(book)

    {:ok,
     socket
     |> assign(:current_author, current_author)
     |> assign(:book, book)
     |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    IndiePaperWeb.BookView.render("edit.html", assigns)
  end

  def handle_event("validate", %{"book" => book_params}, socket) do
    changeset =
      socket.assigns.book
      |> Books.change_book(book_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:changeset, changeset)}
  end

  def handle_event("update_book_listing", %{"book" => book_params}, socket) do
    case Books.update_book(socket.assigns.current_author, socket.assigns.book, book_params) do
      {:ok, updated_book} ->
        socket =
          redirect(
            socket,
            to: Routes.dashboard_path(socket, :index)
          )

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end
end
