defmodule IndiePaperWeb.DashboardLibraryLiveTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_author

  test "shows navbar with Library", %{conn: conn} do
    {:ok, view, _html} = live(conn, dashboard_library_path(conn))

    library_link = element(view, "[data-test=library-link]")

    assert has_element?(library_link)
  end

  test "shows books that reader has purchased", %{conn: conn, author: author} do
    [order1, order2] = insert_pair(:order, customer: author)
    order3 = insert(:order)
    {:ok, view, _html} = live(conn, dashboard_library_path(conn))

    assert view |> library_book(order1.book) |> has_element?()
    assert view |> library_book(order2.book) |> has_element?()
    refute view |> library_book(order3.book) |> has_element?()
  end

  defp library_book(view, book) do
    element(view, "[data-test=book-#{book.id}]", book.title)
  end

  defp dashboard_library_path(conn), do: Routes.dashboard_library_path(conn, :index)
end
