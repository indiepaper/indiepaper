defmodule IndiePaperWeb.DraftControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "create/2" do
    test "displays error when invalid", %{conn: conn} do
      result =
        conn
        |> post(Routes.draft_path(conn, :create), %{"draft" => %{}})
        |> html_response(200)

      assert result =~ "Oops"
    end
  end
end
