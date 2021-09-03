defmodule IndiePaper.Drafts do
  alias IndiePaper.Drafts.Draft

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
end
