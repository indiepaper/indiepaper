defmodule IndiePaperWeb.AuthorRegistrationControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  import IndiePaper.AuthorsFixtures

  describe "GET /authors/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.author_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Sign in"
      assert response =~ "Sign up"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn =
        conn
        |> log_in_author(author_fixture())
        |> get(Routes.author_registration_path(conn, :new))

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    end
  end

  describe "POST /authors/register" do
    @tag :capture_log
    test "creates account and logs the author in", %{conn: conn} do
      email = unique_author_email()

      conn =
        post(conn, Routes.author_registration_path(conn, :create), %{
          "author" => valid_author_attributes(email: email)
        })

      assert get_session(conn, :author_token)
      assert redirected_to(conn) =~ "/secure/finish"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/dashboard")
      response = html_response(conn, 200)

      assert response =~ "Dashboard"
      assert response =~ "Sign out"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.author_registration_path(conn, :create), %{
          "author" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
