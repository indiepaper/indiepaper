defmodule IndiePaperWeb.Pages.Components.NavBar do
  use IndiePaperWeb.PageHelpers

  def click_sign_in(session) do
    session
    |> click(link("Sign in"))
  end

  def has_sign_in_link?(session) do
    session
    |> assert_has(link("Sign in"))
  end

  def has_dashboard_link?(session) do
    session
    |> assert_has(data("test", "dashboard-link", text: "Dashboard"))
  end

  def has_sign_out?(session) do
    session
    |> click(data("test", "navbar-profile"))
    |> assert_has(link("Sign out"))
  end

  def click_sign_out(session) do
    session
    |> click(data("test", "navbar-profile"))
    |> click(link("Sign out"))
  end

  def click_start_writing(session) do
    session
    |> click(link("Start Writing"))
  end
end
