defmodule IndiePaper.Publication do
  alias Ecto.Multi
  alias IndiePaper.Repo
  alias IndiePaper.{Books, Chapters}

  def publish_book(%Books.Book{} = book) do
    book_with_draft = book |> Books.with_assoc(:draft)

    Multi.new()
    |> Multi.update_all(:chapters, Chapters.publish_chapters_query(book_with_draft.draft), [])
    |> Multi.update(:book, Books.publish_book_changeset(book))
    |> Repo.transaction()
    |> case do
      {:ok, %{book: published_book}} -> {:ok, published_book}
    end
  end
end
