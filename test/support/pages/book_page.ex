defmodule IndiePaperWeb.Pages.BookPage do
  use IndiePaperWeb.PageHelpers

  def has_book_title?(session, title) do
    session
    |> assert_has(data("test", "title", text: title))
  end
end
