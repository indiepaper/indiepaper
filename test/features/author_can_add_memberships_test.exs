defmodule IndiePaperWeb.Feature.AuthorCanAddMembershipsTest do
  use IndiePaperWeb.ConnCase

  import Phoenix.LiveViewTest

  test "authors with payment connected authors can see the membership link", %{
    conn: conn
  } do
    author = insert(:author)

    conn = conn |> log_in_author(author)

    {:ok, view, _html} = live(conn, Routes.dashboard_path(conn, :index))

    {:ok, view, _html} =
      view
      |> element(memberships_link())
      |> render_click()
      |> follow_redirect(conn, Routes.dashboard_memberships_path(conn, :index))

    assert view |> element(".page-heading", "Memberships") |> has_element?()
  end

  test "readers cannot see memberships", %{conn: conn} do
    reader = insert(:author, account_status: :confirmed, is_payment_connected: false)
    conn = conn |> log_in_author(reader)

    {:ok, view, _html} = live(conn, Routes.dashboard_path(conn, :index))

    refute view |> element(memberships_link()) |> has_element?()
  end

  defp memberships_link() do
    "[data-test=memberships-link]"
  end
end
