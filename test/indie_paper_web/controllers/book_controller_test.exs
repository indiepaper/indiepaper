defmodule IndiePaperWeb.BookControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "create/2" do
    test "returns error when book has no title", %{conn: conn} do
      book = insert(:book)
      book_params = params_for(:book, title: nil)

      response =
        conn
        |> log_in_author(book.author)
        |> post(Routes.book_path(conn, :create), %{
          "book" => book_params
        })
        |> html_response(200)

      assert response =~ "be blank"
    end
  end

  describe "update/2" do
    test "redirects to dashboard if book is not published", %{conn: conn} do
      book = insert(:book, status: :pending_publication)

      response =
        conn
        |> log_in_author(book.author)
        |> patch(Routes.book_path(conn, :update, book), %{"book" => %{title: "Updated Title"}})
        |> redirected_to()

      assert response =~ "dashboard"
    end

    test "returns error when invalid update params", %{conn: conn} do
      book = insert(:book)

      response =
        conn
        |> log_in_author(book.author)
        |> patch(Routes.book_path(conn, :update, book), %{
          "book" => %{"title" => nil}
        })
        |> html_response(200)

      assert response =~ "be blank"
    end
  end
end
