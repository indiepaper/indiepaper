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
        placeholder_content_json(params["title"], "Awesome content for your chapter")
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
    Repo.all(from c in Chapter, where: c.draft_id == ^draft.id, order_by: c.chapter_index)
  end

  def get_title_from_content_json(content_json) do
    case ExJSONPath.eval(content_json, "$.content[0].content[0].text") do
      {:ok, [title]} -> title |> String.slice(0..29)
      _ -> nil
    end
  end
end
