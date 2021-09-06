defmodule IndiePaperWeb.DraftController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Drafts

  def new(conn, _params) do
    changeset = Drafts.change_draft(%Drafts.Draft{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_author: current_author}} = conn, %{"draft" => draft_params}) do
    case Drafts.create_draft_with_placeholder_chapters(current_author, draft_params) do
      {:ok, draft} ->
        conn
        |> redirect(to: Routes.draft_path(conn, :edit, draft))

      {:error, changeset} ->
        conn |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => draft_id}) do
    draft = Drafts.get_draft!(draft_id) |> Drafts.with_chapters()
    render(conn, "edit.html", draft: draft)
  end
end
