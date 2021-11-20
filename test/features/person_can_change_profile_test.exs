defmodule IndiePaperWeb.Feature.PersonCanChangeProfileTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_author

  test "person can change their profile", %{conn: conn} do
    %{username: username, first_name: first_name} = params_for(:author)
    {:ok, view, _html} = live(conn, Routes.settings_profile_path(conn, :edit))

    html =
      view
      |> form("[data-test=profile-form]", %{username: username, first_name: first_name})
      |> render_submit()
      |> follow_redirect(to: Routes.dashboard_path(conn, :index))

    assert html =~ first_name
  end
end
