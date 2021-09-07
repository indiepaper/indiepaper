defmodule IndiePaper.Drafts.DraftTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Drafts.Draft

  describe "changeset/2" do
    test "validates that title is required" do
      draft_params = params_for(:draft, title: nil)

      changeset = Draft.changeset(%Draft{}, draft_params)

      assert "can't be blank" in errors_on(changeset).title
    end

    test "asserts author is present" do
      draft_params = params_for(:draft)
      {:error, changeset} = Draft.changeset(%Draft{}, draft_params) |> Repo.insert()

      assert "can't be blank" in errors_on(changeset).author
    end
  end
end
