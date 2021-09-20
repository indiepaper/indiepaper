defmodule IndiePaper.ProductsTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Products

  describe "default_product_changeset/1" do
    test "creates default product" do
      book = insert(:book)
      {:ok, product} = Products.default_read_online_product_changeset(book) |> Repo.insert()

      assert product.title == "Read Online"
      assert product.book_id == book.id
    end
  end

  describe "change_product/2" do
    test "returns changeset with given attrs" do
      changeset = Products.change_product(%Products.Product{}, %{title: "Product Title"})

      assert changeset.changes.title == "Product Title"
    end
  end

  describe "create_product/2" do
    test "creates product associated with book" do
      book = insert(:book)
      product_params = params_for(:product)

      {:ok, product} = Products.create_product(book, product_params)

      assert product.book_id == book.id
      assert product.title == product_params[:title]
    end
  end
end
