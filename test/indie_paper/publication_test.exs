defmodule IndiePaper.PublicationTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.{Publication, Books, Chapters}

  describe "publish_book/1" do
    test "populate chapter with published content_json" do
      book = insert(:book, status: :pending_publication)

      {:ok, book} = Publication.publish_book(book)
      assert Books.is_published?(book)

      book = book |> Books.with_assoc(:draft)
      chapters = Chapters.list_chapters(book.draft)

      Enum.each(chapters, fn {chapter} ->
        assert chapter.content_json == chapter.published_content_json
      end)
    end
  end
end
