defmodule IndiePaperWeb.DashboardMembershipsLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "shows create new tier button when empty membership_tiers", %{conn: conn} do
    author = insert(:author, membership_tiers: [])

    conn =
      conn
      |> log_in_author(author)

    {:ok, view, _html} = live(conn, dashboard_memberships_path(conn))

    assert element(view, create_new_tier_when_empty()) |> has_element?()
  end

  test "authors without payment_connected get redirected to Stripe page", %{conn: conn} do
    author = insert(:author, is_payment_connected: false)
    conn = conn |> log_in_author(author)

    live(conn, dashboard_memberships_path(conn))
    |> follow_redirect(conn, Routes.profile_stripe_connect_path(conn, :new))
  end

  test "author can click on create new tier", %{conn: conn} do
    author = insert(:author)
    conn = conn |> log_in_author(author)
    {:ok, view, _html} = live(conn, dashboard_memberships_path(conn))

    view
    |> element(create_new_tier_when_empty())
    |> render_click()

    assert has_element?(view, membership_tier_form())
  end

  test "author can create a new membership tier", %{conn: conn} do
    author = insert(:author, membership_tiers: [])
    membership_tier_params = params_for(:membership_tier)
    conn = conn |> log_in_author(author)
    {:ok, view, _html} = live(conn, Routes.dashboard_memberships_path(conn, :new))

    {:ok, _, html} =
      view
      |> form(membership_tier_form(),
        membership_tier: membership_tier_params
      )
      |> render_submit()
      |> follow_redirect(conn, dashboard_memberships_path(conn))

    assert html =~ membership_tier_params[:title]
  end

  test "author is notified of errors on change", %{conn: conn} do
    author = insert(:author)
    conn = conn |> log_in_author(author)
    {:ok, view, _html} = live(conn, Routes.dashboard_memberships_path(conn, :new))

    view
    |> form(membership_tier_form(),
      membership_tier: %{}
    )
    |> render_change()

    assert render(view) =~ "can&#39;t be blank"
  end

  test "author is notified of errors on submit", %{conn: conn} do
    author = insert(:author)
    conn = conn |> log_in_author(author)
    {:ok, view, _html} = live(conn, Routes.dashboard_memberships_path(conn, :new))

    view
    |> form(membership_tier_form(),
      membership_tier: %{title: nil}
    )
    |> render_submit()

    assert render(view) =~ "can&#39;t be blank"
  end

  test "author can edit already existing membership", %{conn: conn} do
    membership_tier = insert(:membership_tier)
    conn = conn |> log_in_author(membership_tier.author)
    {:ok, view, _html} = live(conn, Routes.dashboard_memberships_path(conn, :new))

    view
    |> element("[data-test=membership-tier-edit-#{membership_tier.id}]")
    |> render_click()

    assert has_element?(view, membership_tier_form())
  end

  test "author can edit a new membership tier", %{conn: conn} do
    membership_tier = insert(:membership_tier)
    conn = conn |> log_in_author(membership_tier.author)

    {:ok, view, _html} =
      live(conn, Routes.dashboard_memberships_path(conn, :edit, membership_tier))

    {:ok, _, html} =
      view
      |> form(membership_tier_form(),
        membership_tier: %{title: "Updated Title"}
      )
      |> render_submit()
      |> follow_redirect(conn, dashboard_memberships_path(conn))

    assert html =~ "Updated Title"
    refute html =~ membership_tier.title
  end

  defp dashboard_memberships_path(conn), do: Routes.dashboard_memberships_path(conn, :index)

  defp create_new_tier_when_empty(),
    do: "[data-test=create-new-tier-when-empty"

  defp membership_tier_form(), do: "[data-test=membership-tier-form]"
end
