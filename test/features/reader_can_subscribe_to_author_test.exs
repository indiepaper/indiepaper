defmodule IndiePaperWeb.Feature.ReaderCanSubscribeToAuthorTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias IndiePaper.WebhookHandler

  test "reader can subscribe to author via memberships", %{conn: conn} do
    reader = insert(:author)
    author = insert(:author)
    membership_tier = insert(:membership_tier, author: author)
    conn = conn |> log_in_author(reader)

    {:ok, view, _html} = live(conn, Routes.author_page_path(conn, :show, author))

    view
    |> element("[data-test=subscribe-#{membership_tier.id}]")
    |> render_click()
    |> follow_redirect(conn)

    {:ok, _view, html} = live(conn, Routes.author_page_path(conn, :show, author))

    # Mock a webhook event from Stripe
    WebhookHandler.subscription_checkout_session_completed(
      reader_id: reader.id,
      membership_tier_id: membership_tier.id,
      stripe_checkout_session_id: "test_session_id",
      stripe_customer_id: "test_customer_id"
    )

    assert html =~ "Subscribed"

    {:ok, view, _html} = live(conn, Routes.dashboard_path(conn, :index))

    {:ok, _view, html} =
      view
      |> element("[data-test=subscriptions-link]")
      |> render_click()
      |> follow_redirect(conn)

    assert html =~ IndiePaper.Authors.get_full_name(author)
  end
end
