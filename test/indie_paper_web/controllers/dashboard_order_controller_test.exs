defmodule IndiePaperWeb.DashboardOrderControllerTest do
  use IndiePaperWeb.ConnCase, async: true

  describe "index/2" do
    test "shows order success message when stripe_checkout_success param is present", %{
      conn: conn
    } do
      author = insert(:author)

      response =
        conn
        |> log_in_author(author)
        |> get(Routes.dashboard_order_path(conn, :index, stripe_checkout_success: true))
        |> html_response(200)

      assert response =~ "Your purchase has been"
    end
  end
end
