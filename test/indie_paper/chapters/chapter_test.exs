defmodule IndiePaper.Chapters.ChapterTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Chapters.Chapter

  describe "changeset/2" do
    test "chapter_index should be a positive integer" do
      changeset = Chapter.changeset(%Chapter{}, %{chapter_index: -1})

      assert "must be greater than or equal to 0" in errors_on(changeset).chapter_index
    end
  end
end
