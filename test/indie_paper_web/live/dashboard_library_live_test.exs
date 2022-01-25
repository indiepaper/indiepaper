defmodule IndiePaperWeb.DashboardLibraryLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_author

  test "shows navbar with Library", %{conn: conn} do
    {:ok, view, _html} = live(conn, dashboard_library_path(conn))

    library_link = element(view, "[data-test=library-link]")

    assert has_element?(library_link)
  end

  @tag :skip
  test "shows books that reader has purchased", %{conn: conn, author: author} do
    [order1, order2] = insert_pair(:order, reader: author)
    order3 = insert(:order)
    {:ok, view, _html} = live(conn, dashboard_library_path(conn))

    assert view |> library_book(order1.book) |> has_element?()

    assert view
           |> element(
             "[data-test=book-#{order1.book.id}]",
             IndiePaper.Authors.get_full_name(order1.book.author)
           )
           |> has_element?()

    assert view |> library_book(order2.book) |> has_element?()
    refute view |> library_book(order3.book) |> has_element?()
  end

  test "show payment completed orders only", %{conn: conn, author: author} do
    payment_pending_order = insert(:order, reader: author, status: :payment_pending)

    {:ok, view, _html} = live(conn, dashboard_library_path(conn))

    refute view |> library_book(payment_pending_order.book) |> has_element?()
  end

  test "show payment banner when returning from stripe", %{conn: conn} do
    {:ok, _view, html} =
      live(conn, Routes.dashboard_library_path(conn, :index, stripe_checkout_success: true))

    assert html =~ "checkout has been succesfully completed"
  end

  defp library_book(view, book) do
    element(view, "[data-test=book-#{book.id}]", book.title)
  end

  defp dashboard_library_path(conn), do: Routes.dashboard_library_path(conn, :index)
end
