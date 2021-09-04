defmodule IndiePaperWeb.DashboardController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Publishing

  def index(conn, _params) do
    drafts = Publishing.get_drafts()
    render(conn, "index.html", drafts: drafts)
  end
end
