defmodule IndiePaper.BookPublisherTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.BookPublisher
  alias IndiePaper.Books
  alias IndiePaper.Chapters
  alias IndiePaper.ChapterMembershipTiers

  describe "publish_book/1" do
    test "populate chapter with published content_json" do
      book = insert(:book, status: :pending_publication)

      {:ok, book} = BookPublisher.publish_book(book)
      assert Books.is_published?(book)

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

  describe "publish_serial_chapter!/3" do
    test "publishes book with first chapters" do
      chapter = insert(:chapter)
      draft = insert(:draft, chapters: [chapter])
      book = insert(:book, status: :pending_publication, draft: draft)
      membership_tier = insert(:membership_tier)

      book = BookPublisher.publish_serial_chapter!(book, chapter, [membership_tier.id])
      assert Books.is_published?(book)

      updated_chapter = Chapters.get_chapter!(chapter.id)

      [chapter_membership_tier] = ChapterMembershipTiers.list_membership_tiers(chapter.id)

      assert updated_chapter.published_content_json == chapter.content_json
      assert chapter_membership_tier.membership_tier_id == membership_tier.id
      assert chapter_membership_tier.chapter_id == chapter.id
    end
  end
end