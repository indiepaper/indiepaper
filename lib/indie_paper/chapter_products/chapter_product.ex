defmodule IndiePaper.ChapterProducts.ChapterProduct do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chapter_products" do
    belongs_to :chapter, IndiePaper.Chapters.Chapter
    belongs_to :product, IndiePaper.Products.Product

    timestamps()
  end

  @doc false
  def changeset(chapter_product, attrs) do
    chapter_product
    |> cast(attrs, [:chapter_id, :product_id])
    |> validate_required([:chapter_id, :product_id])
    |> unique_constraint(:membership_tier_id,
      name: :chapter_products_chapter_id_product_id_index
    )
  end
end
