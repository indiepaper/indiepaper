defmodule IndiePaperWeb.Feature.AuthorCanLoginTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{HomePage, LoginPage, DashboardPage}
  alias IndiePaperWeb.Pages.Components.NavBar

  test "author can log in to dashboard and log out", %{session: session} do
    author = insert(:author)

    session
    |> HomePage.visit()
    |> NavBar.click_sign_in()
    |> LoginPage.login(email: author.email, password: author.password)
    |> DashboardPage.has_title?()
    |> NavBar.has_dashboard_link?()
    |> NavBar.click_sign_out()
    |> NavBar.has_sign_in_link?()
  end

  test "author can login with Google", %{session: session} do
    session
    |> HomePage.visit()
    |> NavBar.click_sign_in()
    |> LoginPage.click_sign_in_with_google()
  end
end
