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

    test "creates empty product if the book is pending_publication" do
      book = insert(:book, status: :pending_publication, products: [])

      {:ok, published_book} = Publication.publish_book(book)
      book_with_products = published_book |> Books.with_assoc(:products)

      product = Enum.at(book_with_products.products, 0)

      assert product.title == "Read Online"
    end
  end
end
