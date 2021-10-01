defmodule IndiePaperWeb.ReadControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "index/2" do
    test "redirects to first chapter show", %{conn: conn} do
      order = insert(:order)
      chapter = Enum.at(order.book.draft.chapters, 0)

      response =
        conn
        |> log_in_author(order.customer)
        |> get(Routes.book_read_path(conn, :index, order.book))
        |> redirected_to()

      assert response =~ chapter.id
    end
  end

  describe "show/2" do
    test "unauthorized error when reader has not purchased book", %{conn: conn} do
      order = insert(:order)
      chapter = Enum.at(order.book.draft.chapters, 0)
      reader = insert(:author)

      response =
        conn
        |> log_in_author(reader)
        |> get(Routes.book_read_path(conn, :show, order.book, chapter))
        |> redirected_to(302)

      assert response =~ "/"
    end
  end
end
