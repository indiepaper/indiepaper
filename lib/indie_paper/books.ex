defmodule IndiePaper.Books do
  alias IndiePaper.Repo
  import Ecto.Query

  alias IndiePaper.Books.Book
  alias IndiePaper.Drafts

  def list_books(author) do
    Book
    |> Bodyguard.scope(author)
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

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

  def update_book(book, book_params) do
    book
    |> Book.changeset(book_params)
    |> Repo.update()
  end

  def get_book!(book_id), do: Repo.get!(Book, book_id)

  def with_assoc(book, assoc), do: Repo.preload(book, assoc)

  def is_published?(book), do: book.status == :published
  def is_listing_complete?(book), do: book.status in [:listing_complete, :published]
  def is_pending_publication?(book), do: book.status == :pending_publication

  def update_book_status(book, status) do
    book
    |> Book.status_changeset(%{status: status})
    |> Repo.update()
  end

  def publish_book(book) do
    book
    |> update_book_status(:published)
  end
end
