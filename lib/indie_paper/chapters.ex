defmodule IndiePaper.Chapters do
  import Ecto.Query

  alias IndiePaper.Repo
  alias IndiePaper.Drafts
  alias IndiePaper.Chapters.Chapter

  def change_chapter(%Chapter{} = chapter, attrs \\ %{}) do
    chapter
    |> Chapter.changeset(attrs)
  end

  def create_chapter(draft, params \\ %{}) do
    Ecto.build_assoc(draft, :chapters)
    |> change_chapter(
      Map.put(
        params,
        "content_json",
        placeholder_content_json(params["title"], "Test Content")
      )
    )
    |> Repo.insert()
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

  @spec get_chapter!(String) :: %Chapter{}
  def get_chapter!(id), do: Repo.get!(Chapter, id)

  def update_chapter(chapter, attrs) do
    chapter
    |> Chapter.changeset(attrs)
    |> Repo.update()
  end

  def publish_chapters_query(%Drafts.Draft{} = draft) do
    from(c in Chapter,
      where: c.draft_id == ^draft.id,
      update: [set: [published_content_json: c.content_json]]
    )
  end

  def list_chapters(draft) do
    Repo.all(from c in Chapter, where: c.id == ^draft.id)
  end
end
