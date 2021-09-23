defmodule IndiePaperWeb.ProductController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{Products, Books}

  def new(conn, %{"book_id" => book_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:assets)
    changeset = Products.change_product(%Products.Product{})
    render(conn, "new.html", changeset: changeset, book: book)
  end

  def create(conn, %{"book_id" => book_id, "product" => product_params}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:assets)

    case Products.create_product(book, product_params) do
      {:ok, _product} ->
        redirect(conn, to: Routes.dashboard_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, book: book)
    end
  end

  def edit(conn, %{"book_id" => book_id, "id" => product_id}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:assets)
    product = Products.get_product!(product_id)
    changeset = Products.change_product(product)

    render(conn, "edit.html", book: book, product: product, changeset: changeset)
  end

  def update(conn, %{"book_id" => book_id, "id" => product_id, "product" => product_params}) do
    book = Books.get_book!(book_id) |> Books.with_assoc(:assets)
    product = Products.get_product!(product_id)

    case Products.update_product(product, product_params) do
      {:ok, _updated_product} ->
        redirect(conn, to: Routes.dashboard_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, book: book, product: product)
    end
  end
end
