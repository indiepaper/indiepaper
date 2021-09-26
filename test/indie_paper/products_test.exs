defmodule IndiePaper.ProductsTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Products

  describe "default_read_online_product_changeset/2" do
    test "creates default product" do
      book = insert(:book)
      asset = insert(:asset)

      {:ok, product} =
        Products.default_read_online_product_changeset(book, asset) |> Repo.insert()

      assert product.title == "Read online"
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

  describe "get_product!/1" do
    test "gets product with the given id" do
      product = insert(:product)

      found_product = Products.get_product!(product.id)

      assert product.id == found_product.id
    end
  end

  describe "update_product/2" do
    test "updates product with given params" do
      product = insert(:product)

      {:ok, updated_product} = Products.update_product(product, %{title: "Updated Product"})

      assert updated_product.title == "Updated Product"
    end
  end
end
