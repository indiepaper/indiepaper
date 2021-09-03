defmodule IndiePaperWeb.Pages.DashboardPage do
  use IndiePaperWeb.PageHelpers

  def has_title?(session) do
    session
    |> assert_has(data("test", "title", text: "Dashboard"))
  end
end
