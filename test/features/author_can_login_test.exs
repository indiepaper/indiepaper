defmodule IndiePaperWeb.Feature.AuthorCanLoginTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{HomePage, LoginPage, DashboardPage}
  alias IndiePaperWeb.Pages.Components.NavBar

  test "author can log in to dashboard and log out", %{session: session} do
    author = insert(:author)

    session
    |> HomePage.visit()
    |> NavBar.click_login()
    |> LoginPage.login(author.email)
    |> DashboardPage.is_here?()
    |> NavBar.click_sign_out()
    |> NavBar.has_log_in?()
  end
end
