defmodule IndiePaper.Drafts.DraftTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Drafts.Draft

  describe "changeset/2" do
    test "validates that title is required" do
      changeset = Draft.changeset(%Draft{}, %{})

      assert "can't be blank" in errors_on(changeset).title
    end
  end
end
