defmodule IndiePaperWeb.Pages.LoginPage.Index do
  use IndiePaperWeb.PageHelpers

  def login(session, email) do
    session
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Email"), with: "longpassword123")
  end
end
