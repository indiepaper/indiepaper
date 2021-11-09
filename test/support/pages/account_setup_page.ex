defmodule IndiePaperWeb.Pages.AccountSetupPage do
  use IndiePaperWeb.PageHelpers

  def setup_account(session, first_name: first_name, last_name: last_name, username: username) do
    session
    |> fill_in(text_field("Username"), with: username)
    |> fill_in(text_field("First name"), with: first_name)
    |> fill_in(text_field("Last name"), with: last_name)
    |> click(button("Finish Profile Setup"))
  end
end
