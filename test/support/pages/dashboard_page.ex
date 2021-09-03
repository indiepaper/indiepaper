defmodule IndiePaperWeb.Pages.DashboardPage do
  use IndiePaperWeb.PageHelpers

  def has_sign_out_button?(session) do
    session
    |> assert_has(link("Sign out"))
  end
end
