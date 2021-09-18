defmodule IndiePaperWeb.Pages.Components.DashboardNavBar do
  use IndiePaperWeb.PageHelpers

  def click_create_new(session) do
    session
    |> click(link("Create new"))
  end
end
