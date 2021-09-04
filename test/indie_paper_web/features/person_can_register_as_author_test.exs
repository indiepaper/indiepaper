defmodule IndiePaperWeb.Feature.PersonCanRegisterAsAuthorTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias Pages.{HomePage, Components.NavBar, DashboardPage, RegisterPage}

  test "person can register as author", %{session: session} do
    author = params_for(:author)

    session
    |> HomePage.visit()
    |> NavBar.click_start_writing()
    |> RegisterPage.register(email: author.email, password: author.password)
    |> DashboardPage.has_title?()
    |> NavBar.has_sign_out?()
  end
end
