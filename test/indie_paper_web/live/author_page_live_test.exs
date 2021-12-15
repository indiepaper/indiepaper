defmodule IndiePaperWeb.AuthorPageLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias IndiePaper.Authors

  test "redirects to sign up page when not logged in", %{conn: conn} do
    membership_tier = insert(:membership_tier)
    {:ok, view, _html} = live(conn, Routes.author_page_path(conn, :show, membership_tier.author))

    {:ok, conn} =
      view
      |> element("[data-test=subscribe-#{membership_tier.id}]")
      |> render_click()
      |> follow_redirect(
        conn,
        Routes.author_registration_path(conn, :new,
          return_to: Routes.author_page_path(conn, :show, membership_tier.author)
        )
      )

    assert html_response(conn, 200) =~ Authors.get_full_name(membership_tier.author)
  end
end
