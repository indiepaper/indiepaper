defmodule IndiePaperWeb.DraftPublishController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Drafts

  def new(conn, %{"draft_id" => draft_id}) do
    draft = Drafts.get_draft!(draft_id)
    render("new.html")
  end
end
