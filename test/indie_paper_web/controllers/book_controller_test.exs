defmodule IndiePaperWeb.BookControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "create/2" do
    test "returns error when book has same title", %{conn: conn} do
      book = insert(:book)
      book_params = params_for(:book, title: book.title)

      response =
        conn
        |> log_in_author(book.author)
        |> post(Routes.book_path(conn, :create), %{
          "book" => book_params
        })
        |> html_response(200)

      assert response =~ "has already been taken"
    end
  end

  describe "update/2" do
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

    test "redirects to publish endpoint when the book is pending publication", %{conn: conn} do
      book = insert(:book, status: :pending_publication)

      response =
        conn
        |> log_in_author(book.author)
        |> patch(Routes.book_path(conn, :update, book), %{
          "book" => %{"title" => book.title}
        })
        |> redirected_to(302)

      assert response == Routes.book_publication_path(conn, :create, book)
    end
  end
end
