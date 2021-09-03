defmodule IndiePaperWeb.Feature.VisitHomePageTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.Page

  test "people can visit home page", %{session: session} do
    session
    |> Page.Index.visit()
    |> Page.Index.has_title()
  end
end
