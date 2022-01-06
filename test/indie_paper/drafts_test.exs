defmodule IndiePaper.DraftsTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Drafts

  describe "create_draft_with_placeholder_chapters!/1" do
    test "creates draft with placeholder chapters and associates with given book" do
      book = insert(:book)

      draft = Drafts.create_draft_with_placeholder_chapters!(book)

      assert %Drafts.Draft{} = draft
      assert draft.book_id == book.id

      draft_with_chapters = draft |> Drafts.with_assoc(:chapters)

      assert Enum.find(draft_with_chapters.chapters, fn chapter ->
               chapter.title == "Introduction"
             end)

      assert Enum.find(draft_with_chapters.chapters, fn chapter ->
               chapter.title == "Preface"
             end)
    end
  end

  test "creates draft with single placeholder chapter when serial" do
    book = insert(:book, publishing_type: :pre_order)

    draft = Drafts.create_draft_with_placeholder_chapters!(book)
    draft_with_chapters = draft |> Drafts.with_assoc(:chapters)

    assert Enum.count(draft_with_chapters.chapters) == 1
    assert List.first(draft_with_chapters.chapters).title == "Introduction"
  end

  describe "get_draft/1" do
    test "gets draft by id" do
      draft = insert(:draft)

      inserted_draft = Drafts.get_draft!(draft.id)

      assert draft.id == inserted_draft.id
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
