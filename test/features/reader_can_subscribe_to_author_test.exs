defmodule IndiePaperWeb.Feature.ReaderCanSubscribeToAuthorTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias IndiePaper.ReaderAuthorSubscriptions

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

    ReaderAuthorSubscriptions.create_reader_author_subscription!(%{
      reader_id: reader.id,
      membership_tier_id: membership_tier.id,
      stripe_checkout_session_id: "test",
      status: :active
    })

    {:ok, _view, html} = live(conn, Routes.author_page_path(conn, :show, author))

    assert html =~ "Subscribed"

    {:ok, _view, html} = live(conn, Routes.dashboard_library_path(conn, :index))
    assert html =~ IndiePaper.Authors.get_full_name(author)
  end
end
