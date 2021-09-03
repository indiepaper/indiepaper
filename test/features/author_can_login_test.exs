defmodule IndiePaperWeb.Feature.AuthorCanLoginTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{HomePage, LoginPage, DashboardPage}

  test "author can log in to dashboard", %{session: session} do
    author = insert(:author)

    session
    |> HomePage.visit()
    |> HomePage.click_login()
    |> LoginPage.login(author.email)
    |> DashboardPage.has_sign_out_button?()
  end
end
