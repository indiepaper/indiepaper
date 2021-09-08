defmodule IndiePaperWeb.DraftChapterController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Chapters

  def edit(conn, %{"draft_id" => draft_id, "id" => id}) do
    chapter = Chapters.get_chapter!(id)
    json(conn, chapter.content_json)
  end

  def update(conn, %{"draft_id" => draft_id, "id" => id}) do
  end
end
