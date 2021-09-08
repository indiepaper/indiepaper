defmodule IndiePaperWeb.Features.AuthorCanEditDraftTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{DraftPage, LoginPage, DashboardPage}

  test "author can edit draft", %{session: session} do
    draft = insert(:draft)
    draft_chapter = Enum.at(draft.chapters, 0)

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: draft.author.email, password: draft.author.password)
    |> DashboardPage.click_edit_draft()
    |> DraftPage.Edit.has_draft_title(draft.title)
    |> DraftPage.Edit.has_draft_chapter_title?(draft_chapter.title)
  end
end
