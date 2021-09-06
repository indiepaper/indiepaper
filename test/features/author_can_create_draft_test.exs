defmodule IndiePaperWeb.Feature.AuthorCanCreateDraftTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{DraftPage, LoginPage, DashboardPage}

  test "author can create draft", %{session: session} do
    draft_params = params_for(:draft)
    author = insert(:author)

    session
    |> DraftPage.New.visit()
    |> LoginPage.login(email: author.email, password: author.password)
    |> DraftPage.New.fill_form(draft_params)
    |> DraftPage.New.submit_form()
    |> DraftPage.Edit.has_draft_title(draft_params[:title])
    |> DraftPage.Edit.has_draft_chapter_title?("Introduction")
    |> DashboardPage.visit_page()
    |> DashboardPage.has_draft_title?(draft_params[:title])
  end
end
