defmodule IndiePaperWeb.Pages.RegisterPage do
  use IndiePaperWeb.PageHelpers

  def register(session, email: email, password: password) do
    session
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Password"), with: password)
    |> click(button("Register"))
  end
end
