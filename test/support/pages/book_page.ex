defmodule IndiePaperWeb.Pages.BookPage do
  use IndiePaperWeb.PageHelpers

  def has_book_title?(session, title) do
    session
    |> assert_has(data("test", "title", text: title))
  end
end

defmodule IndiePaperWeb.Pages.BookPage.New do
  use IndiePaperWeb.PageHelpers

  def fill_form(session, attrs) do
    session
    |> fill_in(text_field("Title"), with: attrs[:title])
    |> fill_in(text_field("Short description"), with: attrs[:short_description])
    |> fill_in(text_field("Long Description"), with: attrs[:long_description_html])
  end

  def click_publish(session) do
    session
    |> click(button("Publish Book"))
  end
end

defmodule IndiePaperWeb.Pages.BookPage.Show do
  use IndiePaperWeb.PageHelpers

  def has_book_title?(session, _title) do
    session
  end
end
