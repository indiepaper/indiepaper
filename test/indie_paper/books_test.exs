defmodule IndiePaper.BooksTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Books
  alias IndiePaper.Books.Book
  alias IndiePaper.Drafts

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
    end

    test "creates a book and associates draft with it" do
      book_params = params_for(:book)
      author = insert(:author)

      {:ok, book} = Books.create_book(author, book_params)

      book_with_draft = book |> Books.with_draft()

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
end
