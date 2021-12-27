defmodule IndiePaper.Products do
  @behaviour Bodyguard.Policy

  def authorize(:update_product, %{id: author_id}, product) do
    product_with_book = product |> with_assoc(:book)
    author_id == product_with_book.book.author_id
  end

  def authorize(_, _, _), do: true

  alias IndiePaper.Repo
  alias IndiePaper.Products.Product

  def change_product(%Product{} = product, attrs \\ %{}) do
    product
    |> Product.changeset(attrs)
  end

  def default_read_online_product_changeset(book, asset, title) do
    Ecto.build_assoc(book, :products)
    |> Product.changeset(%{
      title: title,
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

  def update_product(current_author, product, params) do
    with :ok <- Bodyguard.permit(__MODULE__, :update_product, current_author, product) do
      product
      |> Product.changeset(params)
      |> Repo.update()
    end
  end

  def get_product!(id), do: Repo.get!(Product, id)

  def with_assoc(product, assoc), do: Repo.preload(product, assoc)
end
