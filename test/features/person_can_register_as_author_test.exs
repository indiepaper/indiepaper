defmodule IndiePaperWeb.Feature.PersonCanRegisterAsAuthorTest do
  use IndiePaperWeb.FeatureCase, async: false

  alias IndiePaperWeb.Pages.{Components.NavBar, DashboardPage, RegisterPage, AccountSetupPage}

  test "person can register as author", %{session: session} do
    author = params_for(:author)

    session
    |> RegisterPage.visit_page()
    |> RegisterPage.sign_up(email: author.email, password: author.password)
    |> AccountSetupPage.setup_account(
      first_name: author.first_name,
      last_name: author.last_name,
      username: author.username
    )
    |> DashboardPage.has_title?()
    |> DashboardPage.click_resend_confirmation_email()
    |> DashboardPage.has_confirmation_email_text?()
    |> NavBar.has_sign_out?()
  end

  test "person can register as author with socials", %{session: session} do
    session
    |> RegisterPage.visit_page()
    |> RegisterPage.has_sign_up_with_google?()
    |> RegisterPage.has_sign_up_with_twitter?()
  end
end
