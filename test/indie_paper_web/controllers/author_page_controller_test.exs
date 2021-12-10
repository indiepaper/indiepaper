defmodule IndiePaperWeb.AuthorPageControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "show/2" do
    test "reader can see memberships on author page", %{conn: conn} do
      membership_tier = insert(:membership_tier)
      conn = conn |> log_in_author(membership_tier.author)

      html =
        conn
        |> get(Routes.author_page_path(conn, :show, membership_tier.author))
        |> html_response(200)

      assert html =~ membership_tier.title
    end
  end
end
