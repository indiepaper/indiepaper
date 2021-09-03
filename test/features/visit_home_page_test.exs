defmodule IndiePaperWeb.VisitHomePageTest do
  use IndiePaperWeb.FeatureCase, async: true

  test "people can visit home page", %{session: session} do
    session
    |> visit("/")
    |> assert_has(data("test", "title", text: "IndiePaper"))
  end
end
