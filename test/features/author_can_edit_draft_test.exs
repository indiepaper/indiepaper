defmodule IndiePaperWeb.Features.AuthorCanEditDraftTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{DraftPage, LoginPage}

  test "author can edit draft", %{session: session} do
    author = insert(:author)
    draft = insert(:draft)

    session
    |> DraftPage.Edit.visit_page(draft: draft)
    |> LoginPage.login(email: author.email, password: author.password)
  end
end
