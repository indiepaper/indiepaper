defmodule IndiePaperWeb.Pages.DashboardPage do
  use IndiePaperWeb.PageHelpers

  def visit_page(session) do
    session
    |> visit(Routes.dashboard_path(@endpoint, :index))
  end

  def has_title?(session) do
    session
    |> assert_has(data("test", "title", text: "Your Books"))
  end

  def has_book_title?(session, title) do
    session
    |> assert_has(data("test", "book-title", text: title))
  end

  def not_has_draft_title?(session, title) do
    session
    |> refute_has(data("test", "draft-title", text: title))
  end

  def click_edit_draft(session) do
    session
    |> click(link("Edit draft"))
  end

  def click_connect_stripe(session) do
    session
    |> click(link("Connect Stripe"))
  end

  def click_edit_listing(session) do
    session
    |> click(link("Edit listing"))
  end

  def book_has_pending_publication_status?(session) do
    session
    |> assert_has(data("test", "book-status", text: "Pending publication"))
  end
end
