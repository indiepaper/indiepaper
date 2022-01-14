defmodule IndiePaperWeb.DraftLive.Edit do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Drafts
  alias IndiePaper.Books
  alias IndiePaper.Chapters

  on_mount IndiePaperWeb.AuthorAuthLive

  @impl true
  def mount(%{"id" => draft_id}, _session, socket) do
    draft = Drafts.get_draft!(draft_id) |> Drafts.with_assoc([:chapters, :book])
    last_updated_chapter = Chapters.get_last_updated_chapter(draft.id)

    case Bodyguard.permit(Drafts, :edit_draft, socket.assigns.current_author, draft) do
      :ok ->
        {:ok,
         assign(socket,
           draft: draft,
           chapters: draft.chapters,
           selected_chapter: last_updated_chapter,
           page_title: draft.book.title
         )}

      _ ->
        {:ok,
         socket
         |> put_flash(:error, "You do not have access to that resource.")
         |> redirect(to: Routes.author_session_path(socket, :new))}
    end
  end

  @impl true
  def handle_event("select_chapter", %{"chapter_id" => chapter_id}, socket) do
    selected_chapter = Chapters.get_chapter!(chapter_id)
    {:noreply, socket |> assign(selected_chapter: selected_chapter)}
  end

  @impl true
  def handle_event("editor_reconnected", %{"content_json" => contentJson}, socket) do
    {:ok, chapter} =
      Chapters.update_chapter(socket.assigns.selected_chapter, %{content_json: contentJson})

    {:noreply, assign(socket, selected_chapter: chapter)}
  end

  @impl true
  def handle_event("update_selected_chapter", %{"delta" => delta}, socket) do
    chapter = Chapters.get_chapter!(socket.assigns.selected_chapter.id)

    case JSONPatch.patch(chapter.content_json, delta) do
      {:ok, updated_content_json} ->
        title = Chapters.get_title_from_content_json(updated_content_json)

        {:ok, _chapter} =
          Chapters.update_chapter(chapter, %{
            content_json: updated_content_json,
            title: title || chapter.title
          })

        {:reply, %{data: :ok}, socket}

      {:error, _, _} ->
        {:reply, %{data: :error}, socket}
    end
  end

  @impl true
  def handle_event("add_chapter", _, socket) do
    last_chapter = Drafts.get_last_chapter(socket.assigns.draft)

    {:ok, chapter} =
      Chapters.create_chapter(
        socket.assigns.draft,
        Map.put(%{"title" => "New Chapter"}, "chapter_index", last_chapter.chapter_index + 1)
      )

    draft = Drafts.get_draft!(socket.assigns.draft.id) |> Drafts.with_assoc([:chapters, :book])

    {:noreply, socket |> assign(selected_chapter: chapter, chapters: draft.chapters)}
  end
end
