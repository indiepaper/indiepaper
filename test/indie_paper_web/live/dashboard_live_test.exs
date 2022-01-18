defmodule IndiePaperWeb.DashboardLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  test "don't show connect_stripe button is the author already has payment connected", %{
    conn: conn
  } do
    author = insert(:author)

    response =
      conn
      |> log_in_author(author)
      |> get(Routes.dashboard_path(conn, :index))
      |> html_response(200)

    refute response =~ "Connect Stripe</a>"
  end

  test "show assets on Dashboard", %{conn: conn} do
    author = insert(:author)
    insert(:book, author: author, assets: [build(:asset, type: :pdf, title: "PDF")])

    html =
      conn
      |> log_in_author(author)
      |> get(Routes.dashboard_path(conn, :index))
      |> html_response(200)

    assert html =~ "Assets"
    assert html =~ "PDF"
  end
end
