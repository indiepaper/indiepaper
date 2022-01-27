defmodule IndiePaperWeb.HomePageController do
  use IndiePaperWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(external: "https://indiepaper.me")
  end
end
