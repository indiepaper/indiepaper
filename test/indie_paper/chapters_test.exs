defmodule IndiePaper.ChaptersTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Chapters

  describe "placeholder_chapter/1" do
    test "returns changeset of placeholder chapter for empty draft" do
      chapter = Chapters.placeholder_chapter(title: "Placeholder Title")

      assert %Ecto.Changeset{changes: %{title: "Placeholder Title"}} = chapter
    end
  end
end
