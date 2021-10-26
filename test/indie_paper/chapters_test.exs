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

  describe "publish_chapters_query" do
    test "sets published_content_json with current_content_json" do
      draft = insert(:draft)

      {_, nil} = Chapters.publish_chapters_query(draft) |> Repo.update_all([])
      chapters = Chapters.list_chapters(draft)

      Enum.each(chapters, fn chapter ->
        assert chapter.content_json == chapter.published_content_json
      end)
    end
  end

  describe "list_chapters/1" do
    test "lists chapters associated with draft" do
      draft = insert(:draft)
      chapter = insert(:chapter)

      chapters = Chapters.list_chapters(draft)

      assert Enum.all?(chapters, fn chapter -> chapter.draft_id == draft.id end)
      refute Enum.find(chapters, fn ch -> ch.id == chapter.id end)
    end
  end

  describe "get_title_from_content_json" do
    test "gets the chapter title from content json" do
      chapter =
        insert(:chapter,
          content_json: Chapters.placeholder_content_json("Test Title", "Test Content")
        )

      title = Chapters.get_title_from_content_json(chapter.content_json)

      assert title == "Test Title"
    end

    test "returns nil when no title exists" do
      chapter = insert(:chapter, content_json: %{})

      title = Chapters.get_title_from_content_json(chapter.content_json)

      assert title == nil
    end
  end
end
