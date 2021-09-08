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
end
