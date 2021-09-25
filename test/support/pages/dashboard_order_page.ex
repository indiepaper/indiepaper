defmodule IndiePaperWeb.Pages.DashboardOrderPage do
  use IndiePaperWeb.PageHelpers

  def visit_page(session) do
    session
    |> visit(Routes.dashboard_order_path(@endpoint, :index))
  end

  def has_order_status?(session, status) do
    session
    |> assert_has(data("test", "order-status", text: status))
  end

  def has_book_title?(session, title) do
    session
    |> assert_has(data("test", "order-book-title", text: title))
  end

  def has_product_title?(session, title) do
    session
    |> assert_has(data("test", "order-product-title", text: title))
  end
end
