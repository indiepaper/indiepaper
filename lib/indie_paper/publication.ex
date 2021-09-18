defmodule IndiePaper.Publication do
  alias IndiePaper.{Books, Chapters}

  def publish_book(%Books.Book{} = book) do
    book_with_draft = book |> Books.with_assoc(:draft)

    case Chapters.publish_chapters(book_with_draft.draft) do
      {:ok, _} ->
        Books.publish_book(book)
    end
  end
end
