defmodule IndiePaperWeb.ProductController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{Products, Books}

  def new(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id)
    changeset = Products.change_product(%Products.Product{})
    render(conn, "new.html", changeset: changeset, book: book)
  end

  def create(conn, %{"book_id" => book_id, "product" => product_params}) do
    book = Books.get_book!(book_id)

    case Products.create_product(book, product_params) do
      {:ok, _product} ->
        redirect(conn, to: Routes.dashboard_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, book: book)
    end
  end
end
