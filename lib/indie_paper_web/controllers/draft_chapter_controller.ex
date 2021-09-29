defmodule IndiePaperWeb.DraftChapterController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{Chapters, Drafts}

  def new(conn, %{"draft_id" => draft_id}) do
    draft = Drafts.get_draft!(draft_id)
    changeset = Chapters.change_chapter(%Chapters.Chapter{})
    render(conn, "new.html", changeset: changeset, draft: draft)
  end

  def edit(conn, %{"draft_id" => draft_id, "id" => id}) do
    draft = Drafts.get_draft!(draft_id)
    chapter = Chapters.get_chapter!(id)
    changeset = Chapters.change_chapter(chapter)
    render(conn, "edit.html", changeset: changeset, draft: draft, chapter: chapter)
  end

  def create(conn, %{"draft_id" => draft_id, "chapter" => chapter_params}) do
    draft = Drafts.get_draft!(draft_id) |> Drafts.with_assoc(:chapters)
    last_chapter = Drafts.get_last_chapter(draft)

    {:ok, _chapter} =
      Chapters.create_chapter(
        draft,
        Map.put(chapter_params, "chapter_index", last_chapter.chapter_index + 1)
      )

    redirect(conn, to: Routes.draft_path(conn, :edit, draft))
  end

  def show(conn, %{"draft_id" => _draft_id, "id" => id}) do
    chapter = Chapters.get_chapter!(id)
    json(conn, chapter.content_json)
  end

  def update(conn, %{"draft_id" => draft_id, "id" => id, "chapter" => chapter_params}) do
    draft = Drafts.get_draft!(draft_id) |> Drafts.with_assoc(:chapters)
    chapter = Chapters.get_chapter!(id)

    {:ok, _chapter} =
      Chapters.update_chapter(
        chapter,
        chapter_params
      )

    redirect(conn, to: Routes.draft_path(conn, :edit, draft))
  end

  def update(conn, %{"id" => id, "content_json" => content_json}) do
    chapter = Chapters.get_chapter!(id)
    {:ok, _chapter} = Chapters.update_chapter(chapter, %{content_json: content_json})
    json(conn, %{})
  end
end
