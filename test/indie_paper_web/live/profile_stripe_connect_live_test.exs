defmodule IndiePaperWeb.ProfileStripeConnectLiveTest do
  use IndiePaperWeb.ConnCase, aysnc: true

  import Phoenix.LiveViewTest

  test "redirect to Stripe to confirm account", %{conn: conn} do
    author = insert(:author, stripe_connect_id: nil, account_status: :confirmed)
    conn = log_in_author(conn, author)
    {:ok, view, html} = live(conn, Routes.profile_stripe_connect_path(conn, :new))

    assert html =~ "United States"
    assert html =~ "Connect Stripe"

    {:error, {:redirect, %{to: redirected_url}}} =
      view
      |> form("[data-test=stripe-connect-form]", stripe_connect: %{country_code: "US"})
      |> render_submit()

    assert redirected_url =~ "stripe"
  end
end
