defmodule IndiePaper.Chapters do
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
end
