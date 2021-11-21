defmodule IndiePaperWeb.Feature.VisitHomePageTest do
  use IndiePaperWeb.FeatureCase, async: false

  alias IndiePaperWeb.Pages.HomePage

  test "people can visit home page", %{session: session} do
    session
    |> HomePage.visit()
    |> HomePage.has_title()
  end
end
