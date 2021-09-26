defmodule IndiePaperWeb.Feature.PersonCanRegisterAsAuthorTest do
  use IndiePaperWeb.FeatureCase, async: true

  alias IndiePaperWeb.Pages.{Components.NavBar, DashboardPage, RegisterPage}

  test "person can register as author", %{session: session} do
    author = params_for(:author)

    session
    |> RegisterPage.visit_page()
    |> RegisterPage.sign_up(email: author.email, password: author.password)
    |> DashboardPage.has_title?()
    |> NavBar.has_sign_out?()
  end

  test "person can register as author with Socials", %{session: session} do
    session
    |> RegisterPage.visit_page()
    |> RegisterPage.has_sign_up_with_google?()
    |> RegisterPage.has_sign_up_with_twitter?()
  end
end
