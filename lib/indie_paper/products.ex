defmodule IndiePaper.Products do
  alias IndiePaper.Repo
  alias IndiePaper.Products.Product

  def change_product(%Product{} = product, attrs \\ %{}) do
    product
    |> Product.changeset(attrs)
  end

  def default_read_online_product_changeset(book, asset) do
    Ecto.build_assoc(book, :products)
    |> Product.changeset(%{
      title: "Read online",
      description: "Read the book in our web version",
      price: 1500
    })
    |> Product.asset_changeset(asset)
  end

  def create_product(book, params) do
    Ecto.build_assoc(book, :products)
    |> Product.changeset(params)
    |> Repo.insert()
  end

  def update_product(product, params) do
    product
    |> Product.changeset(params)
    |> Repo.update()
  end

  def get_product!(id), do: Repo.get!(Product, id)
end
