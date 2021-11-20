defmodule IndiePaperWeb.Feature.PersonCanChangeProfileTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_author

  test "person can change their profile", %{conn: conn} do
    %{username: username, first_name: first_name, last_name: last_name} = params_for(:author)

    {:ok, view, _html} = live(conn, Routes.settings_profile_path(conn, :edit))

    {:ok, conn} =
      view
      |> form("[data-test=profile-form]", %{
        author: %{
          username: username,
          first_name: first_name,
          last_name: last_name
        }
      })
      |> render_submit()
      |> follow_redirect(conn, Routes.dashboard_path(conn, :index))

    html = html_response(conn, 200)

    assert html =~ first_name
    assert html =~ last_name
  end
end
