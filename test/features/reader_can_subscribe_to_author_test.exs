defmodule IndiePaperWeb.Feature.ReaderCanSubscribeToAuthorTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "reader can subscribe to author via memberships", %{conn: conn} do
    reader = insert(:author)
    author = insert(:author)
    membership_tier = insert(:membership_tier, author: author)
    conn = conn |> log_in_author(reader)

    {:ok, view, _html} = live(conn, Routes.author_page_path(conn, :show, author))

    view
    |> element("[data-test=subscribe-membership-tier-#{membership_tier.id}]")
    |> render_click()
    |> follow_redirect(conn)
  end
end
