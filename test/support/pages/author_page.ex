defmodule IndiePaperWeb.Pages.AuthorPage.Show do
  use IndiePaperWeb.PageHelpers

  def has_book_title?(session, title) do
    session
    |> assert_has(link(title))
  end
end
