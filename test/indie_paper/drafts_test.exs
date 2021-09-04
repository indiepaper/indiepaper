defmodule IndiePaper.DraftsTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Drafts

  describe "change_draft/1" do
    test "creates empty changeset" do
      assert %Ecto.Changeset{} = Drafts.change_draft(%Drafts.Draft{})
    end
  end

  describe "create_draft/1" do
    test "creates draft with given params" do
      draft_params = string_params_for(:draft)

      {:ok, draft} = Drafts.create_draft(draft_params)

      assert %Drafts.Draft{} = draft
      assert draft.title == draft_params["title"]
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
end
