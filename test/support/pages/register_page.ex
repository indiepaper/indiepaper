defmodule IndiePaperWeb.Pages.RegisterPage do
  use IndiePaperWeb.PageHelpers

  def visit_page(session) do
    session
    |> visit(Routes.author_registration_path(@endpoint, :new))
  end

  def sign_up(session, email: email, password: password) do
    session
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Password"), with: password)
    |> click(button("Sign up"))
  end

  def click_sign_up_with_google(session) do
    session
    |> click(link("Sign up with Google"))
  end
end
