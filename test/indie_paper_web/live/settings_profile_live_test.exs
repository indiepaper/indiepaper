defmodule IndiePaperWeb.SettingsProfileLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "redirects to registration page when author is not present", %{conn: conn} do
    {:error, {:redirect, %{to: registration_path}}} = live(conn, settings_profile_path(conn))

    assert registration_path == Routes.author_registration_path(conn, :new)
  end

  setup :register_and_log_in_author

  test "show changeset error when data is invalid", %{conn: conn} do
    insert(:author, username: "testusername")
    {:ok, view, _html} = live(conn, settings_profile_path(conn))

    view
    |> form("[data-test=profile-form]", %{author: %{username: "testusername"}})
    |> render_submit()

    assert render(view) =~ "has already been taken"
  end

  defp settings_profile_path(conn) do
    Routes.settings_profile_path(conn, :edit)
  end
end
