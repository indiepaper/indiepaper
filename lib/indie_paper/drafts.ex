defmodule IndiePaper.Drafts do
  @behaviour Bodyguard.Policy

  def authorize(:edit_draft, %{id: author_id}, %{book: %{author_id: author_id}}), do: true
  def authorize(_, _, _), do: false

  alias IndiePaper.Repo

  alias IndiePaper.Drafts.Draft
  alias IndiePaper.Chapters
  alias IndiePaper.Books

  def create_draft_with_placeholder_chapters!(%Books.Book{publishing_type: :vanilla} = book) do
    create_draft_changeset(book)
    |> Draft.chapters_changeset([
      Chapters.placeholder_chapter(title: "Introduction", chapter_index: 0),
      Chapters.placeholder_chapter(title: "Preface", chapter_index: 1),
      Chapters.placeholder_chapter(title: "Chapter 1", chapter_index: 2),
      Chapters.placeholder_chapter(title: "Chapter 2", chapter_index: 3)
    ])
    |> Repo.insert!()
  end

  def create_draft_with_placeholder_chapters!(%Books.Book{} = book) do
    create_draft_changeset(book)
    |> Draft.chapters_changeset([
      Chapters.placeholder_chapter(title: "Introduction", chapter_index: 0)
    ])
    |> Repo.insert!()
  end

  defp create_draft_changeset(book) do
    Ecto.build_assoc(book, :draft)
    |> Draft.changeset()
  end

  def get_draft!(id) do
    Repo.get!(Draft, id)
  end

  def with_assoc(%Draft{} = draft, assoc) do
    draft
    |> Repo.preload(assoc)
  end

  def get_first_chapter(%Draft{chapters: chapters}) do
    Enum.min_by(chapters, fn chapter -> chapter.chapter_index end)
  end

  def get_last_chapter(%Draft{chapters: chapters}) do
    Enum.max_by(chapters, fn chapter -> chapter.chapter_index end)
  end
end
