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
    |> Book.changeset(%{
      short_description: "Short description about your book",
      long_description_html: "<h1>You love your book, let the world know</h1>"
    })
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
  def is_pending_publication?(book), do: book.status == :pending_publication

  def update_book_status(book, status) do
    book
    |> Book.status_changeset(%{status: status})
    |> Repo.update()
  end

  def publish_book_changeset(book) do
    book
    |> Book.status_changeset(%{status: :published})
  end

  def get_read_online_product(book) do
    book_with_products = book |> with_assoc(:products)
    book_with_products.products |> Enum.at(0)
  end

  def get_author(book) do
    book_with_author = book |> with_assoc(:author)
    book_with_author.author
  end
end
