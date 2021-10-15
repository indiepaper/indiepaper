defmodule IndiePaper.Books do
  @behaviour Bodyguard.Policy

  def authorize(:update_book, %{id: author_id}, %{author_id: author_id}), do: true
  def authorize(_, _, _), do: false

  alias IndiePaper.Repo
  import Ecto.Query

  alias IndiePaper.Books.Book
  alias IndiePaper.Drafts
  alias IndiePaper.Chapters

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
      long_description_html: "<h2>You love your book, let the world know</h2>"
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

  def update_book(current_author, book, book_params) do
    with :ok <- Bodyguard.permit(__MODULE__, :update_book, current_author, book) do
      book
      |> Book.changeset(book_params)
      |> Repo.update()
    end
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

  def has_one_published_book?(author) do
    from(b in Book, where: b.author_id == ^author.id and b.status == :published)
    |> Repo.aggregate(:count) > 0
  end

  def get_published_chapters(book) do
    book_with_draft = book |> with_assoc(:draft)
    chapters = Chapters.list_chapters(book_with_draft.draft)
    chapters |> Enum.filter(fn c -> not is_nil(c.published_content_json) end)
  end
end
