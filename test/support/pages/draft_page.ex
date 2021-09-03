defmodule IndiePaperWeb.Pages.DraftPage.New do
  use IndiePaperWeb.PageHelpers

  def visit(session) do
    session
    |> visit(Routes.draft_path(@endpoint, :new))
  end

  def has_title(session) do
    session
    |> assert_has(data("test", "title", text: "Create Draft"))
  end

  def fill_form(session, params) do
    session
    |> fill_in(text_field("Title"), with: params[:title])
  end

  def submit_form(session) do
    session
  end
end

defmodule IndiePaperWeb.Pages.DraftPage.Edit do
  use IndiePaperWeb.PageHelpers

  def visit(session) do
    session
    |> visit(Routes.draft_path(@endpoint, :edit))
  end

  def has_draft_title(session, title) do
    session
  end
end
