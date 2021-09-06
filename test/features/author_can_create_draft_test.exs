defmodule IndiePaperWeb.Feature.AuthorCanCreateDraftTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{DraftPage, LoginPage, DashboardPage, Components.DashboardNavBar}

  test "author can create draft", %{session: session} do
    draft_params = params_for(:draft)
    author = insert(:author)

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: author.email, password: author.password)
    |> DashboardNavBar.click_create_new()
    |> DraftPage.New.fill_form(draft_params)
    |> DraftPage.New.submit_form()
    |> DraftPage.Edit.has_draft_title(draft_params[:title])
    |> DraftPage.Edit.has_draft_chapter_title?("Introduction")
    |> DraftPage.Edit.has_draft_chapter_title?("Preface")
    |> DashboardPage.visit_page()
    |> DashboardPage.has_draft_title?(draft_params[:title])
  end
end
