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
  end

  def click_publish(session) do
    session
    |> click(button("Publish Book"))
  end
end
