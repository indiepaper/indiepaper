defmodule IndiePaperWeb.Pages.DashboardPage do
  use IndiePaperWeb.PageHelpers

  def visit_page(session) do
    session
    |> visit(Routes.dashboard_path(@endpoint, :index))
  end

  def has_title?(session) do
    session
    |> assert_has(data("test", "title", text: "Dashboard"))
  end

  def has_draft_title?(session, title) do
    session
    |> assert_has(data("test", "draft-title", text: title))
  end

  def not_has_draft_title?(session, title) do
    session
    |> refute_has(data("test", "draft-title", text: title))
  end
end
