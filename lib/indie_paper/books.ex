defmodule IndiePaper.Books do
  alias IndiePaper.Repo

  alias IndiePaper.Books.Book

  def change_book(%Book{} = book, attrs \\ %{}) do
    book
    |> Book.changeset(attrs)
  end

  def create_book(author, params) do
    Ecto.build_assoc(author, :books)
    |> Book.changeset(params)
    |> Repo.insert()
  end

  def get_book!(book_id), do: Repo.get!(Book, book_id)

  def with_draft(book), do: Repo.preload(book, :draft)
end
