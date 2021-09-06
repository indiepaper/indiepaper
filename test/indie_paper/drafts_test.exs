defmodule IndiePaper.DraftsTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Drafts

  describe "change_draft/1" do
    test "creates empty changeset" do
      assert %Ecto.Changeset{} = Drafts.change_draft(%Drafts.Draft{})
    end
  end

  describe "create_draft/1" do
    test "creates draft with given params and inserts default chapters" do
      draft_params = string_params_for(:draft)
      author = insert(:author)

      {:ok, draft} = Drafts.create_draft(author, draft_params)

      assert %Drafts.Draft{} = draft
      assert draft.title == draft_params["title"]
      assert draft.author_id == author.id

      draft_with_chapters = draft |> Drafts.with_chapters()

      assert Enum.find(draft_with_chapters.chapters, fn chapter ->
               chapter.title == "Introduction"
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

  describe "with_chapters/1" do
    test "loads associated chapters of draft" do
      draft = insert(:draft)
      first_chapter = Enum.at(draft.chapters, 0)

      inserted_draft = Drafts.get_draft!(draft.id) |> Drafts.with_chapters()
      first_inserted_chapter = Enum.at(inserted_draft.chapters, 0)

      assert first_chapter.title == first_inserted_chapter.title
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
end
