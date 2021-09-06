defmodule IndiePaper.Chapters do
  alias IndiePaper.Chapters.Chapter

  def change_chapter(%Chapter{} = chapter, attrs \\ %{}) do
    chapter
    |> Chapter.changeset(attrs)
  end

  def placeholder_chapter(title: title) do
    change_chapter(%Chapter{}, %{
      title: title
    })
  end
end
