defmodule IndiePaper.PublicationTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.{Publication, Books}

  describe "publish_book/1" do
    test "populate chapter with published content_json" do
      book = insert(:book)

      {:ok, book} = Publication.publish_book(book)
      book_with_draft_chapters = book |> Books.with_assoc(draft: :chapters)

      assert Books.is_published?(book)

      Enum.each(book_with_draft_chapters.draft.chapters, fn {chapter} ->
        assert chapter.content_json == chapter.published_content_json
      end)
    end
  end
end
