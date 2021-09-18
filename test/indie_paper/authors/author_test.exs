defmodule IndiePaper.Authors.AuthorTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Authors.Author

  describe "profile_changeset/2" do
    test "unique stripe_connect_id" do
      [author1, author2] = insert_pair(:author)

      {:error, changeset} =
        Author.internal_profile_changeset(author2, %{stripe_connect_id: author1.stripe_connect_id})
        |> Repo.update()

      assert "has already been taken" in errors_on(changeset).stripe_connect_id
    end
  end
end
