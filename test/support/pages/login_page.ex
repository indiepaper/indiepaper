defmodule IndiePaperWeb.Pages.LoginPage.Index do
  use IndiePaperWeb.PageHelpers

  def visit(session) do
    session
    |> visit(Routes.author_session_path(@endpoint, :new))
  end

  def login(session, email) do
    session
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Password"), with: "longpassword123")
    |> click(button("Log in"))
  end
end
