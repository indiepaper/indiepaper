defmodule IndiePaperWeb.AuthorConfirmationControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  alias IndiePaper.Authors
  alias IndiePaper.Repo
  import IndiePaper.AuthorsFixtures

  setup do
    %{author: author_fixture()}
  end

  describe "GET /authors/confirm" do
    test "renders the resend confirmation page", %{conn: conn} do
      conn = get(conn, Routes.author_confirmation_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Resend confirmation instructions</h1>"
    end
  end

  describe "POST /authors/confirm" do
    @tag :capture_log
    test "sends a new confirmation token", %{conn: conn, author: author} do
      conn =
        post(conn, Routes.author_confirmation_path(conn, :create), %{
          "author" => %{"email" => author.email}
        })

      assert redirected_to(conn) == "/secure/sign-in"
      assert get_flash(conn, :info) =~ "Confirmation Email has been sent, check for instructions"
      assert Repo.get_by!(Authors.AuthorToken, author_id: author.id).context == "confirm"
    end

    test "does not send confirmation token if Author is confirmed", %{conn: conn, author: author} do
      Repo.update!(Authors.Author.confirm_changeset(author))

      conn =
        post(conn, Routes.author_confirmation_path(conn, :create), %{
          "author" => %{"email" => author.email}
        })

      assert redirected_to(conn) == "/secure/sign-in"
      assert get_flash(conn, :info) =~ "Confirmation Email has been sent, check for instructions"
      refute Repo.get_by(Authors.AuthorToken, author_id: author.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.author_confirmation_path(conn, :create), %{
          "author" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/secure/sign-in"
      assert get_flash(conn, :info) =~ "Confirmation Email has been sent, check for instructions"
      assert Repo.all(Authors.AuthorToken) == []
    end
  end

  describe "GET /users/confirm/:token" do
    test "renders the confirmation page", %{conn: conn} do
      conn = get(conn, Routes.author_confirmation_path(conn, :edit, "some-token"))
      response = html_response(conn, 200)
      assert response =~ "Confirm account</h1>"

      form_action = Routes.author_confirmation_path(conn, :update, "some-token")
      assert response =~ "action=\"#{form_action}\""
    end
  end

  describe "POST /authors/confirm/:token" do
    test "confirms the given token once", %{conn: conn, author: author} do
      token =
        extract_author_token(fn url ->
          Authors.deliver_author_confirmation_instructions(author, url)
        end)

      conn = post(conn, Routes.author_confirmation_path(conn, :update, token))
      assert redirected_to(conn) == "/secure/sign-in"
      assert get_flash(conn, :info) =~ "confirmed"
      assert Authors.get_author!(author.id).confirmed_at
      refute get_session(conn, :author_token)
      assert Repo.all(Authors.AuthorToken) == []

      # When not logged in
      conn = post(conn, Routes.author_confirmation_path(conn, :update, token))
      assert redirected_to(conn) == "/secure/sign-in"
      assert get_flash(conn, :error) =~ "Author confirmation link is invalid or it has expired"

      # When logged in
      conn =
        build_conn()
        |> log_in_author(author)
        |> post(Routes.author_confirmation_path(conn, :update, token))

      assert redirected_to(conn) == "/dashboard"
      refute get_flash(conn, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, author: author} do
      conn = post(conn, Routes.author_confirmation_path(conn, :update, "oops"))
      assert redirected_to(conn) == "/secure/sign-in"
      assert get_flash(conn, :error) =~ "Author confirmation link is invalid or it has expired"
      refute Authors.get_author!(author.id).confirmed_at
    end
  end
end
