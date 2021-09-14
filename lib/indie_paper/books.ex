defmodule IndiePaper.Books do
  alias IndiePaper.Repo

  alias IndiePaper.Drafts
  alias IndiePaper.Books.Book

  def change_book(%Book{} = book, attrs \\ %{}) do
    book
    |> Book.changeset(attrs)
  end

  def create_book(draft = %Drafts.Draft{}, params) do
    Ecto.build_assoc(draft, :book)
    |> Book.changeset(params)
    |> Repo.insert()
  end

  def get_book!(book_id), do: Repo.get!(Book, book_id)
end
