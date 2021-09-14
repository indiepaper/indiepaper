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
    test "creates a book with given params" do
      book_params = params_for(:book)
      draft = insert(:draft)

      {:ok, book} = Books.create_book(draft, book_params)

      assert book.draft_id == draft.id
      assert book.title == book_params[:title]
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
