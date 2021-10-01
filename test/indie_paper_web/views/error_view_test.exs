defmodule IndiePaperWeb.ErrorViewTest do
  use IndiePaperWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html", %{conn: conn} do
    assert render_to_string(IndiePaperWeb.ErrorView, "404.html", conn: conn) == "404"
  end

  test "renders 500.html", %{conn: conn} do
    assert render_to_string(IndiePaperWeb.ErrorView, "500.html", conn: conn) == "500"
  end
end
