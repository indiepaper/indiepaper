defmodule IndiePaper.BookPublisherTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.BookPublisher
  alias IndiePaper.Books
  alias IndiePaper.Chapters
  alias IndiePaper.ChapterProducts

  describe "publish_book/1" do
    test "populate chapter with published content_json" do
      book = insert(:book, status: :pending_publication)

      {:ok, book} = BookPublisher.publish_book(book)
      assert Books.publication_in_progress?(book)
      assert_enqueued(worker: IndiePaper.Workers.TypesetWorker, args: %{id: book.id})

      book = book |> Books.with_assoc(:draft)
      chapters = Chapters.list_chapters(book.draft)

      Enum.each(chapters, fn chapter ->
        assert chapter.content_json == chapter.published_content_json
      end)
    end

    test "creates empty product if the book is pending_publication" do
      book = insert(:book, status: :pending_publication, products: [])

      found_book = Books.get_book!(book.id)
      {:ok, published_book} = BookPublisher.publish_book(found_book)

      book_with_products = published_book |> Books.with_assoc(products: :assets)

      product = Enum.at(book_with_products.products, 0)
      asset = Enum.at(product.assets, 0)

      assert product.title == "Read online"
      assert asset.title == "Read online"
    end
  end

  describe "publish_pre_order_chapter/1" do
    test "publishes free chapter" do
      chapter = insert(:chapter)
      draft = insert(:draft, chapters: [chapter])
      book = insert(:book, status: :pending_publication, draft: draft)

      published_book = BookPublisher.publish_pre_order_chapter!(book, chapter, nil)

      assert Books.is_published?(published_book)

      updated_chapter = Chapters.get_chapter!(chapter.id)

      assert updated_chapter.published_content_json == chapter.content_json
      assert Chapters.is_free?(updated_chapter)
    end

    test "publishes chapters associated with product" do
      chapter = insert(:chapter)
      draft = insert(:draft, chapters: [chapter])
      book = insert(:book, status: :pending_publication, draft: draft)
      product = insert(:product, book: book)

      BookPublisher.publish_pre_order_chapter!(book, chapter, product.id)
      [chapter_product] = ChapterProducts.list_chapter_products(chapter)

      updated_chapter = Chapters.get_chapter!(chapter.id)

      assert chapter_product.product_id == product.id
      refute Chapters.is_free?(updated_chapter)

      # Ignore call when already published with product
      BookPublisher.publish_pre_order_chapter!(book, chapter, product.id)

      BookPublisher.publish_pre_order_chapter!(book, chapter, nil)
      chapter_product = ChapterProducts.get_chapter_product(chapter.id, product.id)
      free_chapter = Chapters.get_chapter!(chapter.id)

      assert Chapters.is_free?(free_chapter)
      refute chapter_product
    end
  end
end
