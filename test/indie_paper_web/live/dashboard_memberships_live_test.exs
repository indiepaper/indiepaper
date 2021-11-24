defmodule IndiePaperWeb.DashboardMembershipsLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "shows create new tier button when empty membership_tiers", %{conn: conn} do
    author = insert(:author, membership_tiers: [])

    conn =
      conn
      |> log_in_author(author)

    {:ok, view, _html} = live(conn, dashboard_memberships_path(conn))

    assert create_new_tier_when_empty_button(view) |> has_element?()
  end

  test "authors without payment_connected get redirected to Stripe page", %{conn: conn} do
    author = insert(:author, is_payment_connected: false)
    conn = conn |> log_in_author(author)

    live(conn, dashboard_memberships_path(conn))
    |> follow_redirect(conn, Routes.profile_stripe_connect_path(conn, :new))
  end

  test "author can create a new membership tier", %{conn: conn} do
    author = insert(:author, membership_tiers: [])
    membership_tier_params = params_for(:membership_tier)
    conn = conn |> log_in_author(author)
    {:ok, view, _html} = live(conn, dashboard_memberships_path(conn))

    view
    |> create_new_tier_when_empty_button()
    |> render_click()
    |> follow_redirect(conn, Routes.dashboard_memberships_path(conn, :new))
    |> form("[data-test=membership-tier-form]", %{"membership_tier" => membership_tier_params})
    |> render_submit()
    |> follow_redirect(conn, dashboard_memberships_path(conn))
  end

  defp dashboard_memberships_path(conn), do: Routes.dashboard_memberships_path(conn, :index)

  defp create_new_tier_when_empty_button(view),
    do: element(view, "[data-test=create-new-tier-when-empty-button")
end
