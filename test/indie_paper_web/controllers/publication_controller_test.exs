defmodule IndiePaperWeb.PublicationControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "create/2" do
    test "redirects to books/edit if the listing is incomplete", %{conn: conn} do
      author = insert(:author)
      book = insert(:book, author: author, status: :pending_publication)

      response =
        conn
        |> log_in_author(author)
        |> post(Routes.book_publication_path(conn, :create, book))
        |> redirected_to(302)

      assert response == Routes.book_path(conn, :edit, book)
    end
  end
end
