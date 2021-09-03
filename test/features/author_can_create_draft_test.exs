defmodule IndiePaperWeb.Feature.AuthorCanCreateDraftTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{DraftPage, LoginPage}
  alias IndiePaper.Authors

  test "author can create draft", %{session: session} do
    draft_params = params_for(:draft)
    author = insert(:author)

    session
    |> DraftPage.New.visit()
    |> LoginPage.Index.login(author.email)
    |> DraftPage.New.fill_form(draft_params)
    |> DraftPage.New.submit_form()
    |> DraftPage.Edit.has_draft_title(draft_params[:title])
  end
end
