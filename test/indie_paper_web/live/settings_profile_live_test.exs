defmodule IndiePaperWeb.SettingsProfileLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "redirects to registration page when author is not present", %{conn: conn} do
    {:error, {:redirect, %{to: registration_path}}} = live(conn, settings_profile_path(conn))

    assert registration_path == Routes.author_registration_path(conn, :new)
  end

  describe "authenticated person can" do
    setup :register_and_log_in_author

    test "show changeset error when data is invalid", %{conn: conn} do
      insert(:author, username: "testusername")
      {:ok, view, _html} = live(conn, settings_profile_path(conn))

      html =
        view
        |> form(profile_form(), %{author: %{username: "testusername"}})
        |> render_submit()

      assert html =~ "has already been taken"
      assert html =~ "Oops"
    end

    test "shows validation error when data is invalid", %{conn: conn} do
      {:ok, view, _html} = live(conn, settings_profile_path(conn))

      html =
        view
        |> form(profile_form(), %{author: %{first_name: nil}})
        |> render_change()

      assert html =~ "can&#39;t be blank"
    end
  end

  defp profile_form() do
    "[data-test=profile-form]"
  end

  defp settings_profile_path(conn) do
    Routes.settings_profile_path(conn, :edit)
  end
end
