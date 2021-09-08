defmodule IndiePaperWeb.Features.AuthorCanEditDraftTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{DraftPage, LoginPage, DashboardPage}

  test "author can edit draft", %{session: session} do
    draft = insert(:draft)
    [draft_chapter1, _draft_chapter2] = draft.chapters

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: draft.author.email, password: draft.author.password)
    |> DashboardPage.click_edit_draft()
    |> DraftPage.Edit.has_draft_title(draft.title)
    |> DraftPage.Edit.click_chapter_title(draft_chapter1.title)
    |> DraftPage.Edit.has_chapter_content_title?(
      Enum.at(Enum.at(draft_chapter1.content_json["content"], 0)["content"], 0)["text"]
    )
  end
end
