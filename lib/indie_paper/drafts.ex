defmodule IndiePaper.Drafts do
  alias IndiePaper.Drafts.Draft
  alias IndiePaper.Authors.Author

  alias IndiePaper.Repo

  def change_draft(%Draft{} = draft, attrs \\ %{}) do
    Draft.changeset(draft, attrs)
  end

  def create_draft(params) do
    %Draft{}
    |> Draft.changeset(params)
    |> Repo.insert()
  end

  def get_draft!(id) do
    Repo.get!(Draft, id)
  end

  def with_chapters(%Draft{} = draft) do
    draft
    |> Repo.preload(:chapters)
  end

  def list_drafts(%Author{} = author) do
    Draft
    |> Bodyguard.scope(author)
    |> Repo.all()
  end
end
