defmodule IndiePaper.PublishingTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Publishing

  describe "get_drafts/1" do
    test "returns drafts of current author" do
      [draft1, draft2] = insert_pair(:draft)

      drafts = Publishing.get_drafts()

      assert draft1 in drafts
      assert draft2 in drafts
    end
  end
end
