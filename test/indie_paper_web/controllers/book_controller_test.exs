defmodule IndiePaperWeb.BookControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "create/2" do
    test "returns error when book has same title", %{conn: conn} do
      book = insert(:book)
      book_params = params_for(:book, title: book.title)

      response =
        conn
        |> log_in_author(book.draft.author)
        |> post(Routes.draft_book_path(conn, :create, book.draft), %{
          "book" => book_params
        })
        |> html_response(200)

      assert response =~ "has already been taken"
    end
  end
end
