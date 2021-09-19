defmodule IndiePaper.Products do
  alias IndiePaper.Products.Product

  def default_read_online_product_changeset(book) do
    Ecto.build_assoc(book, :products)
    |> Product.changeset(%{title: "Read Online", description: "Read the book in our web version"})
  end
end
