defmodule IndiePaperWeb.ProductControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "create/2" do
    test "shows error when title is not present", %{conn: conn} do
      book = insert(:book)
      product_params = params_for(:product, title: nil)

      response =
        conn
        |> log_in_author(book.author)
        |> post(Routes.book_product_path(conn, :create, book), %{"product" => product_params})
        |> html_response(200)

      assert response =~ "be blank"
    end
  end
end
