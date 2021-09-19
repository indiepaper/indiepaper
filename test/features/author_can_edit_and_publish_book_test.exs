defmodule IndiePaperWeb.Features.AuthorCanEditAndPublishDraftTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{DraftPage, LoginPage, DashboardPage, BookPage}

  test "author can edit and publish draft", %{session: session} do
    book = insert(:book, status: :pending_publication)
    [draft_chapter1, _draft_chapter2] = book.draft.chapters
    book_params = params_for(:book)

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: book.author.email, password: book.author.password)
    |> DashboardPage.click_edit_draft()
    |> DraftPage.Edit.has_book_title(book.title)
    |> DraftPage.Edit.click_chapter_title(draft_chapter1.title)
    |> DraftPage.Edit.has_chapter_content_title?(
      Enum.at(Enum.at(draft_chapter1.content_json["content"], 0)["content"], 0)["text"]
    )
    |> DraftPage.Edit.click_publish()
    |> BookPage.Show.has_book_title?(book.title)
    |> DashboardPage.visit_page()
    |> DashboardPage.click_update_listing()
    |> BookPage.Edit.fill_form(book_params)
    |> BookPage.Edit.click_publish()
    |> BookPage.Show.has_book_title?(book_params[:title])
  end

  test "author can republish already published book", %{session: session} do
    book = insert(:book, status: :published)

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: book.author.email, password: book.author.password)
    |> DashboardPage.click_edit_draft()
    |> DraftPage.Edit.click_publish()
    |> BookPage.Show.has_book_title?(book.title)
  end

  test "publishing creates read online product", %{session: session} do
    book = insert(:book, status: :published)

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: book.author.email, password: book.author.password)
    |> DashboardPage.click_edit_draft()
    |> DraftPage.Edit.click_publish()
    |> BookPage.Show.select_product("Read Online")
  end
end
