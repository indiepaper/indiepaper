defmodule IndiePaperWeb.Feature.AuthorCanCreateDraftTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.DraftPage

  test "author can create draft", %{session: session} do
    draft_params = params_for(:draft)

    session
    |> DraftPage.New.visit()
    |> DraftPage.New.has_title()
    |> DraftPage.New.fill_form(draft_params)
    |> DraftPage.New.submit_form()
    |> DraftPage.Edit.has_draft_title(draft_params[:title])
  end
end
