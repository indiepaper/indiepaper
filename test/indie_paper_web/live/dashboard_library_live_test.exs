defmodule IndiePaperWeb.DashboardLibraryLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_author

  test "shows navbar with Library", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.dashboard_library_path(conn, :index))

    library_link = element(view, "[data-test=library-link]")

    assert has_element?(library_link)
  end
end
