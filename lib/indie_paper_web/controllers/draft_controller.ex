defmodule IndiePaperWeb.DraftController do
  use IndiePaperWeb, :controller

  action_fallback IndiePaperWeb.FallbackController

  alias IndiePaper.Drafts
  alias IndiePaper.Chapters

  def edit(conn, %{"id" => draft_id}) do
    draft = Drafts.get_draft!(draft_id) |> Drafts.with_assoc([:chapters, :book])
    last_updated_chapter = Chapters.get_last_updated_chapter(draft.id)

    with :ok <- Bodyguard.permit(Drafts, :edit_draft, conn.assigns.current_author, draft) do
      render(conn, "edit.html",
        draft: draft,
        last_updated_chapter: last_updated_chapter,
        page_title: draft.book.title
      )
    end
  end
end
