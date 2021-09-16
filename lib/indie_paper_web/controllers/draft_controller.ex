defmodule IndiePaperWeb.DraftController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Drafts

  def edit(conn, %{"id" => draft_id}) do
    draft = Drafts.get_draft!(draft_id) |> Drafts.with_assoc([:chapters, :book])
    first_chapter = Drafts.get_first_chapter(draft)
    render(conn, "edit.html", draft: draft, first_chapter: first_chapter)
  end
end
