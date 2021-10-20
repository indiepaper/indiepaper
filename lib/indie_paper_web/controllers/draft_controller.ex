defmodule IndiePaperWeb.DraftController do
  use IndiePaperWeb, :controller

  action_fallback IndiePaperWeb.FallbackController

  alias IndiePaper.Drafts

  def edit(conn, %{"id" => draft_id}) do
    draft = Drafts.get_draft!(draft_id) |> Drafts.with_assoc([:chapters, :book])
    first_chapter = Drafts.get_first_chapter(draft)

    with :ok <- Bodyguard.permit(Drafts, :edit_draft, conn.assigns.current_author, draft) do
      render(conn, "edit.html",
        draft: draft,
        first_chapter: first_chapter,
        page_title: draft.book.title
      )
    end
  end
end
