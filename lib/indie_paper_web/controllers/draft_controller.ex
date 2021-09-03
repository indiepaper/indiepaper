defmodule IndiePaperWeb.DraftController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Drafts

  def new(conn, _params) do
    changeset = Drafts.change_draft(%Drafts.Draft{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"draft" => draft_params}) do
    case Drafts.create_draft(draft_params) do
      {:ok, draft} ->
        conn
        |> redirect(to: Routes.draft_path(conn, :edit, draft))
    end
  end

  def edit(conn, %{"id" => draft_id}) do
    draft = Drafts.get_draft!(draft_id)
    render(conn, "edit.html", draft: draft)
  end
end
