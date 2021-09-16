defmodule IndiePaper.DraftsTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Drafts

  describe "change_draft/1" do
    test "creates empty changeset" do
      assert %Ecto.Changeset{} = Drafts.change_draft(%Drafts.Draft{})
    end
  end

  describe "create_draft_with_placeholder_chapters!/1" do
    test "creates draft with placeholder chapters and associates with given book" do
      book = insert(:book)

      draft = Drafts.create_draft_with_placeholder_chapters!(book)

      assert %Drafts.Draft{} = draft
      assert draft.book_id == book.id

      draft_with_chapters = draft |> Drafts.with_chapters()

      assert Enum.find(draft_with_chapters.chapters, fn chapter ->
               chapter.title == "Introduction"
             end)

      assert Enum.find(draft_with_chapters.chapters, fn chapter ->
               chapter.title == "Preface"
             end)
    end
  end

  describe "get_draft/1" do
    test "gets draft by id" do
      draft = insert(:draft)

      inserted_draft = Drafts.get_draft!(draft.id)

      assert draft.id == inserted_draft.id
    end
  end

  describe "list_drafts/1" do
    test "lists drafts of a given author" do
      [draft1, draft2] = insert_pair(:draft)

      drafts = Drafts.list_drafts(draft1.author)

      assert Enum.find(drafts, fn draft -> draft.id == draft1.id end)
      refute Enum.find(drafts, fn draft -> draft.id == draft2.id end)
    end
  end

  describe "get_first_chapter/1" do
    test "returns the first chapter of the draft" do
      draft = insert(:draft, chapters: [build(:chapter, chapter_index: 0)])

      first_chapter = Drafts.get_first_chapter(draft)

      assert first_chapter.chapter_index == 0
    end
  end
end
