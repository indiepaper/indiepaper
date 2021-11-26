defmodule IndiePaperWeb.Feature.ReaderCanSubscribeToAuthorTest do
  use IndiePaperWeb.ConnCase, async: true

  test "reader can subscribe to author via memberships", %{conn: conn} do
    reader = insert(:author)
    author = insert(:author)
    membership_tier = insert(:membership_tier, author: author)
    conn = conn |> log_in_author(author)
  end
end
