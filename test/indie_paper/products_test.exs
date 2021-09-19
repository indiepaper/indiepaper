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
end
