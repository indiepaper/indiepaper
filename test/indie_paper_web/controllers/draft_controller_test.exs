defmodule IndiePaperWeb.DraftControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "edit/2" do
    test "authorization error when authors are different", %{conn: conn} do
      [book1, book2] = insert_pair(:book)

      response =
        conn
        |> log_in_author(book1.author)
        |> get(Routes.draft_path(conn, :edit, book2.draft))
        |> redirected_to(302)

      assert response =~ "/"
    end
  end
end
