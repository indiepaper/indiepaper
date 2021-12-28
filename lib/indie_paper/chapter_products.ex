defmodule IndiePaper.ChapterProducts do
  import Ecto.Query
  alias IndiePaper.Repo

  alias IndiePaper.Chapters
  alias IndiePaper.ChapterProducts.ChapterProduct

  def list_chapter_products(%Chapters.Chapter{} = chapter) do
    from(cp in ChapterProduct, where: cp.chapter_id == ^chapter.id)
    |> Repo.all()
  end

  def new_chapter_product(chapter_id, product_id) do
    %ChapterProduct{}
    |> ChapterProduct.changeset(%{chapter_id: chapter_id, product_id: product_id})
  end
end
