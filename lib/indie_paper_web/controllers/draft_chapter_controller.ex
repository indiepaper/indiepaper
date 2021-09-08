defmodule IndiePaperWeb.DraftChapterController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Chapters

  def edit(conn, %{"draft_id" => draft_id, "id" => id}) do
    chapter = Chapters.get_chapter!(id)
    json(conn, chapter.content_json)
  end

  def update(conn, %{"id" => id, "content_json" => content_json}) do
    chapter = Chapters.get_chapter!(id)
    {:ok, chapter} = Chapters.update_chapter(chapter, %{content_json: content_json})
    json(conn, %{})
  end
end
