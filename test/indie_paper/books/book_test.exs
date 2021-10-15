defmodule IndiePaper.Books.BookTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Books.Book

  describe "changeset/2" do
    test "validation error when title over 100 characters" do
      book = build(:book)

      change_book =
        Book.changeset(book, %{
          title:
            "long chapter with over 100 characters that should trow an error but that, long chapter with over 100 characters that should trow an error but that, long chapter with over 100 characters that should trow an error but that, long chapter with over 100 characters that should trow an error but that"
        })

      assert "should be at most 100 character(s)" in errors_on(change_book).title
    end
  end
end
