defmodule IndiePaper.Products do
  alias IndiePaper.Repo
  alias IndiePaper.Products.Product

  def change_product(%Product{} = product, attrs \\ %{}) do
    product
    |> Product.changeset(attrs)
  end

  def default_read_online_product_changeset(book) do
    Ecto.build_assoc(book, :products)
    |> Product.changeset(%{
      title: "Read Online",
      description: "Read the book in our web version",
      price: 1500
    })
  end

  def create_product(book, params) do
    Ecto.build_assoc(book, :products)
    |> Product.changeset(params)
    |> Repo.insert()
  end
end
