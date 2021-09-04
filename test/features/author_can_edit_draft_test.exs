defmodule IndiePaperWeb.Features.AuthorCanEditDraftTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{DraftPage, LoginPage}

  test "author can edit draft", %{session: session} do
    author = insert(:author)
    draft = insert(:draft)
    draft_chapter = Enum.at(draft.chapters, 0)

    session
    |> DraftPage.Edit.visit_page(draft: draft)
    |> LoginPage.login(email: author.email, password: author.password)
    |> DraftPage.Edit.has_draft_title(draft.title)
    |> DraftPage.Edit.has_draft_chapter_title(draft_chapter.title)
  end
end
