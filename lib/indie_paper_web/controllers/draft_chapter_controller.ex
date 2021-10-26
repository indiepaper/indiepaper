defmodule IndiePaperWeb.DraftChapterController do
  use IndiePaperWeb, :controller

  alias IndiePaper.{Chapters, Drafts}

  def create(conn, %{"draft_id" => draft_id}) do
    draft = Drafts.get_draft!(draft_id) |> Drafts.with_assoc(:chapters)
    last_chapter = Drafts.get_last_chapter(draft)

    {:ok, chapter} =
      Chapters.create_chapter(
        draft,
        Map.put(%{"title" => "New Chapter"}, "chapter_index", last_chapter.chapter_index + 1)
      )

    json(conn, %{chapter: chapter})
  end

  def show(conn, %{"draft_id" => _draft_id, "id" => id}) do
    chapter = Chapters.get_chapter!(id)
    json(conn, %{"contentJSON" => chapter.content_json})
  end

  def update(conn, %{"id" => id, "delta" => delta}) do
    chapter = Chapters.get_chapter!(id)
    {:ok, updated_content_json} = JSONPatch.patch(chapter.content_json, delta)

    title = Chapters.get_title_from_content_json(updated_content_json)

    {:ok, _chapter} =
      Chapters.update_chapter(chapter, %{
        content_json: updated_content_json,
        title: title || chapter.title
      })

    conn
    |> json(%{})
  end
end
