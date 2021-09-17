defmodule IndiePaper.ChaptersTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Chapters

  describe "placeholder_chapter/1" do
    test "returns changeset of placeholder chapter for empty draft" do
      chapter = Chapters.placeholder_chapter(title: "Placeholder Title", chapter_index: 4)

      assert %Ecto.Changeset{changes: %{title: "Placeholder Title", chapter_index: 4}} = chapter
    end
  end

  describe "get_chapter!/1" do
    test "gets the chapter with the given id" do
      chapter = insert(:chapter)

      found_chapter = Chapters.get_chapter!(chapter.id)

      assert chapter.id == found_chapter.id
    end
  end

  describe "update_chapter/2" do
    test "updates chapter with given params" do
      chapter = insert(:chapter)

      {:ok, updated_chapter} = Chapters.update_chapter(chapter, %{title: "Updated Title"})

      assert updated_chapter.title == "Updated Title"
    end
  end

  describe "publish_chapters" do
    test "sets published_content_json with current_content_json" do
      draft = insert(:draft)

      {:ok, chapters} = Chapters.publish_chapters(draft)

      Enum.each(chapters, fn chapter ->
        assert chapter.content_json == chapter.published_content_json
      end)
    end
  end
end
