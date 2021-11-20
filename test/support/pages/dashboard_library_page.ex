defmodule IndiePaperWeb.Pages.DashboardLibraryPage do
  use IndiePaperWeb.PageHelpers

  def visit_page(session) do
    session
    |> visit(Routes.dashboard_library_path(@endpoint, :index))
  end

  def has_book_title?(session, title) do
    session
    |> assert_has(data("test", "order-book-title", text: title))
  end

  def has_product_title?(session, title) do
    session
    |> assert_has(data("test", "order-product-title", text: title))
  end

  def click_read_online(session) do
    session
    |> click(link("read-online-link"))
  end
end
