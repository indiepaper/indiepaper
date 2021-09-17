defmodule IndiePaper.Chapters do
  import Ecto.Query

  alias IndiePaper.Repo
  alias IndiePaper.Drafts
  alias IndiePaper.Chapters.Chapter

  def change_chapter(%Chapter{} = chapter, attrs \\ %{}) do
    chapter
    |> Chapter.changeset(attrs)
  end

  def placeholder_chapter(title: title, chapter_index: chapter_index) do
    change_chapter(%Chapter{}, %{
      title: title,
      chapter_index: chapter_index,
      content_json: placeholder_content_json(title, "Write your masterpiece here.")
    })
  end

  def placeholder_content_json(title, content) do
    %{
      "content" => [
        %{
          "attrs" => %{"level" => 1},
          "content" => [
            %{"text" => title, "type" => "text"}
          ],
          "type" => "heading"
        },
        %{
          "content" => [%{"text" => content, "type" => "text"}],
          "type" => "paragraph"
        }
      ],
      "type" => "doc"
    }
  end

  def get_chapter!(id), do: Repo.get!(Chapter, id)

  def update_chapter(chapter, attrs) do
    chapter
    |> Chapter.changeset(attrs)
    |> Repo.update()
  end

  def publish_chapters(%Drafts.Draft{} = draft) do
    {count, _} =
      from(c in Chapter,
        where: c.draft_id == ^draft.id,
        update: [set: [published_content_json: c.content_json]]
      )
      |> Repo.update_all([])

    {:ok, count}
  end

  def list_chapters(draft) do
    Repo.all(from c in Chapter, where: c.id == ^draft.id)
  end
end
