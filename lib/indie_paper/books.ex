defmodule IndiePaper.Books do
  alias IndiePaper.Repo

  alias IndiePaper.Books.Book
  alias IndiePaper.Drafts

  def change_book(%Book{} = book, attrs \\ %{}) do
    book
    |> Book.changeset(attrs)
  end

  def create_book(author, params) do
    Ecto.build_assoc(author, :books)
    |> Book.initial_draft_changeset(params)
    |> Repo.insert()
  end

  def create_book_with_draft(author, params) do
    case create_book(author, params) do
      {:ok, book} ->
        Drafts.create_draft_with_placeholder_chapters!(book)
        {:ok, book}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def get_book!(book_id), do: Repo.get!(Book, book_id)

  def with_draft(book), do: Repo.preload(book, :draft)
end
