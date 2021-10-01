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
  end

  describe "create_book_with_draft/2" do
    test "creates a book and associates draft with it" do
      book_params = params_for(:book)
      author = insert(:author)

      {:ok, book} = Books.create_book_with_draft(author, book_params)

      book_with_draft = book |> Books.with_assoc(:draft)

      assert book_with_draft.draft.book_id == book.id
    end
  end

  describe "get_book!/1" do
    test "gets book with given id" do
      book = insert(:book)

      found_book = Books.get_book!(book.id)

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
end
