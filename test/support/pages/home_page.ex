defmodule IndiePaperWeb.Pages.HomePage do
  use IndiePaperWeb.PageHelpers

  def visit(session) do
    session
    |> visit(Routes.author_session_path(@endpoint, :new))
  end

  def has_title(session) do
    session
    |> assert_has(data("test", "title", text: "IndiePaper"))
  end
end
