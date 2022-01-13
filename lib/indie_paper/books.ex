defmodule IndiePaper.Books do
  @behaviour Bodyguard.Policy

  def authorize(:update_book, %{id: author_id}, %{author_id: author_id}), do: true
  def authorize(_, _, _), do: false

  alias IndiePaper.Repo
  import Ecto.Query

  alias IndiePaper.Assets
  alias IndiePaper.Books.Book
  alias IndiePaper.Chapters
  alias IndiePaper.Drafts
  alias IndiePaper.Products

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

  def create_book_multi(author, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :book,
      Ecto.build_assoc(author, :books)
      |> Book.initial_draft_changeset(params)
      |> Book.changeset(%{
        short_description: "Short description about your book",
        long_description_html: "<h2>You love your book, let the world know</h2>"
      })
    )
    |> Ecto.Multi.insert(:draft, fn %{book: book} ->
      Drafts.draft_with_placeholder_chapters_changeset(%Book{} = book)
    end)
  end

  def create_book_transaction(multi) do
    Repo.transaction(multi)
    |> case do
      {:ok, %{book: book}} -> {:ok, book}
      {:error, :book, changeset, %{}} -> {:error, changeset}
    end
  end

  def create_book(author, params) do
    create_book_multi(author, params)
    |> maybe_create_pre_order_product_multi()
    |> create_book_transaction()
  end

  def maybe_create_pre_order_product_multi(multi) do
    multi
    |> Ecto.Multi.run(:readable_asset, fn repo, %{book: book} ->
      if(is_pre_order_book?(book)) do
        Assets.readable_asset_changeset(book, "Read online") |> repo.insert()
      else
        {:ok, nil}
      end
    end)
    |> Ecto.Multi.run(:pre_order_readable_asset, fn repo, %{book: book, readable_asset: asset} ->
      if(is_pre_order_book?(book)) do
        Products.default_read_online_product_changeset(book, asset, "Pre-order")
        |> repo.insert()
      else
        {:ok, nil}
      end
    end)
  end

  def update_book(current_author, book, book_params) do
    with :ok <- Bodyguard.permit(__MODULE__, :update_book, current_author, book) do
      book
      |> Book.changeset(book_params)
      |> Repo.update()
    end
  end

  def get_book!(book_id), do: Repo.get!(Book, book_id)
  def get_book_with_draft!(book_id), do: get_book!(book_id) |> with_assoc(:draft)

  def get_book_from_slug!(slug) do
    id = String.slice(slug, -36, 36)
    get_book!(id)
  end

  def with_assoc(book, assoc), do: Repo.preload(book, assoc)

  def is_published?(%Book{} = book), do: book.status == :published
  def is_pending_publication?(%Book{} = book), do: book.status == :pending_publication

  def update_book_status(book, status) do
    book
    |> Book.status_changeset(%{status: status})
    |> Repo.update()
  end

  def publish_book_changeset(%Book{} = book) do
    book
    |> Book.status_changeset(%{status: :published})
  end

  def publish_book(%Book{} = book) do
    book
    |> publish_book_changeset()
    |> Repo.update()
  end

  def get_read_online_product(%Book{} = book) do
    book_with_products = book |> with_assoc(:products)
    book_with_products.products |> Enum.at(0)
  end

  def get_author(%Book{} = book) do
    book_with_author = book |> with_assoc(:author)
    book_with_author.author
  end

  def has_one_published_book?(author) do
    from(b in Book, where: b.author_id == ^author.id and b.status == :published)
    |> Repo.aggregate(:count) > 0
  end

  def get_published_chapters(%Book{} = book) do
    book_with_draft = book |> with_assoc(:draft)
    chapters = Chapters.list_chapters(book_with_draft.draft)
    chapters |> Enum.filter(fn c -> not is_nil(c.published_content_json) end)
  end

  def get_published_books(author) do
    from(b in Book,
      where: b.author_id == ^author.id and b.status == :published,
      order_by: [desc: :updated_at]
    )
    |> Repo.all()
  end

  def has_promo_images?(%Book{} = book) do
    not Enum.empty?(book.promo_images)
  end

  def first_promo_image(%Book{} = book) do
    Enum.at(book.promo_images, 0)
  end

  def is_pre_order_book?(%Book{} = book) do
    book.publishing_type == :pre_order
  end

  def is_vanilla_book?(%Book{} = book) do
    book.publishing_type == :vanilla
  end
end
