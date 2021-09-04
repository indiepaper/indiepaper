defmodule IndiePaperWeb.Pages.Components.NavBar do
  use IndiePaperWeb.PageHelpers

  def click_login(session) do
    session
    |> click(link("Log in"))
  end

  def has_login_link?(session) do
    session
    |> assert_has(link("Log in"))
  end

  def has_dashboard_link?(session) do
    session
    |> assert_has(link("Dashboard"))
  end

  def has_sign_out?(session) do
    session
    |> assert_has(link("Sign out"))
  end

  def click_sign_out(session) do
    session
    |> click(link("Sign out"))
  end

  def click_start_writing(session) do
    session
    |> click(link("Start Writing"))
  end
end
