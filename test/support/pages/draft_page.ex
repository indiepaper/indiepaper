defmodule IndiePaperWeb.Pages.DraftPage.New do
  use IndiePaperWeb.PageHelpers

  def visit(session) do
    session
    |> visit(Routes.draft_path(@endpoint, :new))
  end

  def fill_form(session, params) do
    session
    |> fill_in(text_field("Title"), with: params[:title])
  end

  def submit_form(session) do
    session
    |> click(button("Create"))
  end
end

defmodule IndiePaperWeb.Pages.DraftPage.Edit do
  use IndiePaperWeb.PageHelpers

  def visit_page(session, draft: draft) do
    session
    |> visit(Routes.draft_path(@endpoint, :edit, draft))
  end

  def has_draft_title(session, title) do
    session
    |> assert_has(data("test", "title", text: title))
  end

  def has_draft_chapter_title?(session, title) do
    session
    |> assert_has(data("test", "chapter-title", text: title))
  end

  def click_chapter_title(session, title) do
    session
    |> click(button(title))
  end

  def has_chapter_content_title?(session, title) do
    session
    |> assert_has(Wallaby.Query.text(css(".ProseMirror > h1"), title))
  end

  def click_publish(session) do
    session
    |> click(link("Publish"))
  end
end

defmodule IndiePaperWeb.Pages.DraftPage.Publish.New do
  use IndiePaperWeb.PageHelpers

  def fill_form(session, attrs) do
    session
  end

  def click_publish(session) do
    session
    |> click(button("Publish Book"))
  end
end
