defmodule IndiePaperWeb.CheckoutControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "create/2" do
    test "redirects to stripe checkout page", %{conn: conn} do
      book = insert(:book)

      response =
        conn
        |> post(Routes.book_checkout_path(@endpoint, :create, book))
        |> redirected_to(302)

      assert response =~ "stripe"
    end
  end
end
