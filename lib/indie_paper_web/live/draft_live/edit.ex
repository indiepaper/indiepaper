defmodule IndiePaperWeb.DraftLive.Edit do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Drafts
  alias IndiePaper.Books
  alias IndiePaper.Chapters

  on_mount IndiePaperWeb.AuthorLiveAuth

  @impl true
  def mount(%{"id" => draft_id}, _session, socket) do
    draft = Drafts.get_draft!(draft_id) |> Drafts.with_assoc([:chapters, :book])
    last_updated_chapter = Chapters.get_last_updated_chapter(draft.id)

    case Bodyguard.permit(Drafts, :edit_draft, socket.assigns.current_author, draft) do
      :ok ->
        {:ok,
         assign(socket,
           draft: draft,
           selected_chapter: last_updated_chapter,
           page_title: draft.book.title
         )}

      _ ->
        {:ok,
         socket
         |> put_flash(:error, "You do not have access to that resource.")
         |> push_redirect(to: Routes.page_path(socket, :index))}
    end
  end

  def chapters_to_alpine(chapters) do
    Jason.encode!(chapters)
  end
end
