defmodule IndiePaperWeb.Feature.AuthorCanLoginTest do
  use IndiePaperWeb.FeatureCase, async: false

  alias IndiePaperWeb.Pages.{LoginPage, DashboardPage}
  alias IndiePaperWeb.Pages.Components.NavBar

  test "author can log in to dashboard and log out", %{session: session} do
    author = insert(:author)

    session
    |> DashboardPage.visit_page()
    |> LoginPage.login(email: author.email, password: author.password)
    |> DashboardPage.has_title?()
    |> NavBar.has_dashboard_link?()
    |> NavBar.click_sign_out()
    |> NavBar.has_sign_in_link?()
  end
end
