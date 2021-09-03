defmodule IndiePaperWeb.Pages.LoginPage do
  use IndiePaperWeb.PageHelpers

  def visit(session) do
    session
    |> visit(Routes.author_session_path(@endpoint, :new))
  end

  # Logs the author in with the given email
  # All authors have the same password in test
  def login(session, email) do
    session
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Password"), with: "longpassword123")
    |> click(button("Log in"))
  end
end
