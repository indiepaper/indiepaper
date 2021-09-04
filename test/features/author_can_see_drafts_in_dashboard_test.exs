defmodule IndiePaperWeb.Feature.AuthorCanSeeDraftInDashboardTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{DashboardPage, LoginPage}

  test "author can see drafts in dashboard", %{session: session} do
    draft = insert(:draft)
    second_draft = insert(:draft)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: draft.author.email, password: draft.author.password)
    |> DashboardPage.has_draft_title?(draft.title)
    |> DashboardPage.not_has_draft_title?(second_draft.title)
  end
end
