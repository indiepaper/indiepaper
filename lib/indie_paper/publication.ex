defmodule IndiePaper.Publication do
  alias IndiePaper.{Books, Chapters}

  def publish_book(%Books.Book{} = book) do
    book_with_draft = book |> Books.with_assoc(:draft)

    with {:ok, _} <- Chapters.publish_chapters(book_with_draft.draft),
         {:ok, book} <- Books.publish_book(book) do
      {:ok, book}
    end
  end
end
