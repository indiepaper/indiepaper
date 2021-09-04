defmodule IndiePaperWeb.DashboardController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Drafts

  def index(%{assigns: %{current_author: current_author}} = conn, _params) do
    drafts = Drafts.list_drafts(current_author)
    render(conn, "index.html", drafts: drafts)
  end
end
