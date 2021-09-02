defmodule IndiePaperWeb.PageControllerTest do
  use IndiePaperWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "IndiePaper"
  end
end
