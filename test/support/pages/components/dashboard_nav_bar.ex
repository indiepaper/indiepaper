defmodule IndiePaperWeb.Pages.Components.DashboardNavBar do
  use IndiePaperWeb.PageHelpers

  def click_create_new(session) do
    session
    |> click(data("test", "create-new", text: "Create new"))
  end
end
