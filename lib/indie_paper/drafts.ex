defmodule IndiePaper.Drafts do
  @behaviour Bodyguard.Policy

  def authorize(:create_draft_with_placeholder_chapters, _, _), do: true

  alias IndiePaper.Drafts.Draft
  alias IndiePaper.Authors.Author
  alias IndiePaper.Chapters

  alias IndiePaper.Repo

  def change_draft(%Draft{} = draft, attrs \\ %{}) do
    Draft.changeset(draft, attrs)
  end

  def create_draft_with_placeholder_chapters(%Author{} = author, params) do
    with :ok <- Bodyguard.permit(__MODULE__, :create_draft_with_placeholder_chapters, author, %{}) do
      Ecto.build_assoc(author, :drafts)
      |> Draft.changeset(params)
      |> Draft.chapters_changeset([
        Chapters.placeholder_chapter(title: "Introduction"),
        Chapters.placeholder_chapter(title: "Preface"),
        Chapters.placeholder_chapter(title: "Chapter 1"),
        Chapters.placeholder_chapter(title: "Chapter 2")
      ])
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
