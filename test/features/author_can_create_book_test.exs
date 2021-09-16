defmodule IndiePaperWeb.Feature.AuthorCanCreateBookTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{
    DraftPage,
    BookPage,
    LoginPage,
    DashboardPage,
    Components.DashboardNavBar
  }

  test "author can create draft", %{session: session} do
    book_params = params_for(:book)
    author = insert(:author)

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: author.email, password: author.password)
    |> DashboardNavBar.click_create_new()
    |> BookPage.New.fill_form(book_params)
    |> BookPage.New.submit_form()
    |> DraftPage.Edit.has_book_title(book_params[:title])
    |> DraftPage.Edit.has_draft_chapter_title?("Introduction")
    |> DraftPage.Edit.has_draft_chapter_title?("Preface")
    |> DashboardPage.visit_page()
    |> DashboardPage.has_book_title?(book_params[:title])
  end
end