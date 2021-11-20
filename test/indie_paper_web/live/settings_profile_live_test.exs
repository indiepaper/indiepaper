defmodule IndiePaperWeb.SettingsProfileLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "redirects to registration page when author is not present", %{conn: conn} do
    {:error, {:redirect, %{to: registration_path}}} =
      live(conn, Routes.settings_profile_path(conn, :edit))

    assert registration_path == Routes.author_registration_path(conn, :new)
  end
end
