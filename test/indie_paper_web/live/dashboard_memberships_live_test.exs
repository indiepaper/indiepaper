defmodule IndiePaperWeb.DashboardMembershipsLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "shows create new tier button when empty membership_tiers", %{conn: conn} do
    author = insert(:author, membership_tiers: [])

    conn =
      conn
      |> log_in_author(author)

    {:ok, view, _html} = live(conn, dashboard_memberships_path(conn))

    assert element(view, "[data-test=create-new-tier-button-when-empty]") |> has_element?()
  end

  defp dashboard_memberships_path(conn), do: Routes.dashboard_memberships_path(conn, :index)
end
