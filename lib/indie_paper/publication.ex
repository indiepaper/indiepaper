defmodule IndiePaper.Publication do
  alias IndiePaper.{Books, Chapters}

  def publish_book(%Books.Book{} = book) do
    book_with_draft = book |> Books.with_assoc(:draft)

    {:ok, _} = Chapters.publish_chapters(book_with_draft.draft)
  end
end
