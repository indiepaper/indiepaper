defmodule IndiePaper.BooksTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Books
  alias IndiePaper.Books.Book

  describe "change_book/2" do
    test "returns a book changeset" do
      assert %Ecto.Changeset{} = Books.change_book(%Book{})
    end
  end

  describe "create_book/2" do
    test "creates a book with given params and author" do
      book_params = params_for(:book)
      author = insert(:author)

      {:ok, book} = Books.create_book(author, book_params)

      assert book.author_id == author.id
      assert book.title == book_params[:title]
      assert book.short_description
    end

    test "creates a book and associates draft with it" do
      book_params = params_for(:book)
      author = insert(:author)

      {:ok, book} = Books.create_book(author, book_params)

      book_with_draft = book |> Books.with_assoc(:draft)

      assert book_with_draft.draft.book_id == book.id
    end

    test "throws error when empty title" do
      book_params = params_for(:book, title: nil)
      author = insert(:author)

      {:error, changeset} = Books.create_book(author, book_params)

      assert %{title: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "get_book!/1" do
    test "gets book with given id" do
      book = insert(:book)

      found_book = Books.get_book!(book.id)

      assert found_book.id == book.id
    end
  end

  describe "get_book_from_slug!/1" do
    test "gets book with given slug" do
      book = insert(:book)
      slug = Books.Book.to_slug(book.id, book.title)

      found_book = Books.get_book_from_slug!(slug)

      assert found_book.id == book.id
    end
  end

  describe "list_books/1" do
    test "lists books of a given author" do
      [book1, book2] = insert_pair(:book)

      drafts = Books.list_books(book1.author)

      assert Enum.find(drafts, fn draft -> draft.id == book1.id end)
      refute Enum.find(drafts, fn draft -> draft.id == book2.id end)
    end
  end

  describe "update_book/2" do
    test "updates book with given parameters" do
      book = insert(:book)
      book_params = params_for(:book, title: "Updated Book")

      {:ok, updated_book} = Books.update_book(book.author, book, book_params)

      assert updated_book.title == book_params[:title]
    end
  end

  describe "publish_book_changeset/1" do
    test "returns changeset sets status of book as published" do
      book = insert(:book, status: :pending_publication)

      {:ok, published_book} = Books.publish_book_changeset(book) |> Repo.update()

      assert published_book.status == :published
    end
  end

  describe "get_read_online_product/1" do
    test "gets the one read online product each book has" do
      product = insert(:product, title: "Read online")
      book = insert(:book, products: [product])
      product_from_book = Books.get_read_online_product(book)

      assert product_from_book.title == "Read online"
    end
  end

  describe "get_author/1" do
    test "returns the current author of the book" do
      book = insert(:book)

      author = Books.get_author(book)

      assert author.id == book.author.id
    end
  end

  describe "get_published_chapters/1" do
    test "returns the only published chapters" do
      chapter = insert(:chapter, published_content_json: nil)
      [chapter1, chapter2] = insert_pair(:chapter)
      book = insert(:book, draft: build(:draft, chapters: [chapter1, chapter2, chapter]))

      published_chapters = Books.get_published_chapters(book)

      refute Enum.any?(published_chapters, fn pc -> pc.id == chapter.id end)
      assert Enum.find(published_chapters, fn pc -> pc.id == chapter2.id end)
    end
  end

  describe "get_published_books" do
    test "returns published books of given author" do
      author = insert(:author)
      [book1, book2] = insert_pair(:book, author: author, status: :published)
      book3 = insert(:book, status: :pending_publication, author: author)

      books = Books.get_published_books(author)

      assert Enum.find(books, fn book -> book.id == book1.id end)
      assert Enum.find(books, fn book -> book.id == book2.id end)
      refute Enum.find(books, fn book -> book.id == book3.id end)
    end
  end
end
