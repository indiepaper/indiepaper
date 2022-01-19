defmodule IndiePaperWeb.BookProductLive.New do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.Products

  on_mount IndiePaperWeb.AuthorAuthLive
  on_mount {IndiePaperWeb.AuthorAuthLive, :require_account_status_payment_connected}

  @impl true
  def mount(%{"book_slug" => book_slug}, _session, socket) do
    book = Books.get_book_from_slug!(book_slug)
    changeset = Products.change_product()
    {:ok, socket |> assign(book: book, changeset: changeset, form_submit_error: false)}
  end

  @impl true
  def handle_event("create_product", %{"product" => product_params}, socket) do
    case Products.create_product(socket.assigns.book, product_params) do
      {:ok, _product} ->
        {:noreply, socket |> push_redirect(to: Routes.dashboard_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset, form_submit_error: true)}
    end
  end
end
