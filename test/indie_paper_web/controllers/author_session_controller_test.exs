defmodule IndiePaperWeb.AuthorSessionControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  import IndiePaper.AuthorsFixtures

  setup do
    %{author: author_fixture()}
  end

  describe "GET /authors/log_in" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.author_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn, author: author} do
      conn = conn |> log_in_author(author) |> get(Routes.author_session_path(conn, :new))
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    end
  end

  describe "POST /authors/log_in" do
    test "logs the author in", %{conn: conn, author: author} do
      conn =
        post(conn, Routes.author_session_path(conn, :create), %{
          "author" => %{"email" => author.email, "password" => valid_author_password()}
        })

      assert get_session(conn, :author_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)

      assert response =~ "Dashboard"
      assert response =~ "Sign out"
    end

    test "logs the author in with remember me", %{conn: conn, author: author} do
      conn =
        post(conn, Routes.author_session_path(conn, :create), %{
          "author" => %{
            "email" => author.email,
            "password" => valid_author_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_indie_paper_web_author_remember_me"]
      assert redirected_to(conn) =~ "/"
    end

    test "logs the author in with return to", %{conn: conn, author: author} do
      conn =
        conn
        |> init_test_session(author_return_to: "/foo/bar")
        |> post(Routes.author_session_path(conn, :create), %{
          "author" => %{
            "email" => author.email,
            "password" => valid_author_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
    end

    test "emits error message with invalid credentials", %{conn: conn, author: author} do
      conn =
        post(conn, Routes.author_session_path(conn, :create), %{
          "author" => %{"email" => author.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "Invalid email or password"
    end
  end

  describe "DELETE /authors/log_out" do
    test "logs the author out", %{conn: conn, author: author} do
      conn = conn |> log_in_author(author) |> delete(Routes.author_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :author_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the author is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.author_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :author_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end
end
