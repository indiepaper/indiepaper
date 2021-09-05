defmodule IndiePaperWeb.Pages.HomePage do
  use IndiePaperWeb.PageHelpers

  def visit(session) do
    session
    |> visit(Routes.page_path(@endpoint, :index))
  end

  def has_title(session) do
    session
    |> assert_has(data("test", "title", text: "IndiePaper"))
  end
end
