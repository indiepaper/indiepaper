defmodule IndiePaperWeb.Pages.Components.NavBar do
  use IndiePaperWeb.PageHelpers

  def click_login(session) do
    session
    |> click(link("Log in"))
  end

  def has_log_in?(session) do
    session
    |> assert_has(link("Log in"))
  end

  def click_sign_out(session) do
    session
    |> click(link("Sign out"))
  end
end
