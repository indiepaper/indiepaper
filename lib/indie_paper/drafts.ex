defmodule IndiePaper.Drafts do
  @behaviour Bodyguard.Policy

  def authorize(:create_draft, _, _), do: true

  alias IndiePaper.Drafts.Draft
  alias IndiePaper.Authors.Author

  alias IndiePaper.Repo

  def change_draft(%Draft{} = draft, attrs \\ %{}) do
    Draft.changeset(draft, attrs)
  end

  def create_draft(%Author{} = author, params) do
    with :ok <- Bodyguard.permit(__MODULE__, :create_draft, author, %{}) do
      Ecto.build_assoc(author, :drafts)
      |> Draft.changeset(params)
      |> Repo.insert()
    end
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
