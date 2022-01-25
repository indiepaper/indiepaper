defmodule IndiePaper.Products.ProductTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Products.Product

  describe "changeset/2" do
    test "error when price is less than 0" do
      changeset = Product.changeset(%Product{}, %{price: -90})

      assert errors_on(changeset).price == ["must be greater than $0.99"]
    end
  end
end
