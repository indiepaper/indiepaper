defmodule IndiePaperWeb.Plugs.EnsureAccountStatusPlugTest do
  use IndiePaperWeb.ConnCase, async: true

  alias IndiePaperWeb.Plugs.EnsureAccountStatusPlug

  describe "call/2" do
    test "redirects to Stripe Connect Page when account_status is confirmed and accesses payment_connected",
         %{conn: conn} do
      author = insert(:author, account_status: :confirmed)

      response =
        conn
        |> log_in_author(author)
        |> EnsureAccountStatusPlug.call(:payment_connected)
        |> redirected_to(302)

      assert response = Routes.profile_stripe_connect_path(conn, :new)
    end
  end
end
