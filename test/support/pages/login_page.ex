defmodule IndiePaperWeb.Pages.LoginPage do
  use IndiePaperWeb.PageHelpers

  def visit_page(session) do
    session
    |> visit(Routes.author_session_path(@endpoint, :new))
  end

  # Logs the author in with the given email
  # All authors have the same password in test
  def login(session, email: email, password: password) do
    session
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Password"), with: password)
    |> click(button("Log in"))
  end

  def click_sign_in_with_google(session) do
    session
    |> click(link("Sign in with Google"))
  end
end
