defmodule IndiePaperWeb.BookControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "new/2" do
    test "sets the title of the book from the draft", %{conn: conn} do
      draft = insert(:draft)

      response =
        conn
        |> log_in_author(draft.author)
        |> get(Routes.draft_book_path(conn, :new, draft))
        |> html_response(200)

      assert response =~ draft.title
    end
  end

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
