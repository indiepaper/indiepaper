defmodule IndiePaper.Drafts do
  alias IndiePaper.Repo

  alias IndiePaper.Drafts.Draft
  alias IndiePaper.Authors.Author
  alias IndiePaper.Chapters

  def change_draft(%Draft{} = draft, attrs \\ %{}) do
    Draft.changeset(draft, attrs)
  end

  def create_draft_with_placeholder_chapters!(book) do
    Ecto.build_assoc(book, :draft)
    |> Draft.changeset()
    |> Draft.chapters_changeset([
      Chapters.placeholder_chapter(title: "Introduction", chapter_index: 0),
      Chapters.placeholder_chapter(title: "Preface", chapter_index: 1),
      Chapters.placeholder_chapter(title: "Chapter 1", chapter_index: 2),
      Chapters.placeholder_chapter(title: "Chapter 2", chapter_index: 3)
    ])
    |> Repo.insert!()
  end

  def get_draft!(id) do
    Repo.get!(Draft, id)
  end

  def with_chapters_and_book(%Draft{} = draft) do
    draft
    |> Repo.preload([:chapters, :book])
  end

  def list_drafts(%Author{} = author) do
    Draft
    |> Repo.all()
  end

  def get_first_chapter(%Draft{chapters: chapters}) do
    Enum.min_by(chapters, fn chapter -> chapter.chapter_index end)
  end
end
