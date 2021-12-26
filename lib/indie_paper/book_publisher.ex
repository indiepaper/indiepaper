defmodule IndiePaper.BookPublisher do
  alias Ecto.Multi
  alias IndiePaper.Repo

  alias IndiePaper.Assets
  alias IndiePaper.Books
  alias IndiePaper.Chapters
  alias IndiePaper.Products

  def maybe_create_default_product_and_publish_multi(multi, book) do
    multi
    |> Multi.run(
      :default_readable_asset,
      &maybe_insert_readable_asset(&1, &2, book)
    )
    |> Multi.run(
      :default_product,
      &maybe_insert_default_product(&1, &2, book)
    )
    |> Multi.update(:book, Books.publish_book_changeset(book))
  end

  def publish_book(%Books.Book{} = book) do
    book_with_draft = book |> Books.with_assoc(:draft)

    Multi.new()
    |> Multi.update_all(:chapters, Chapters.publish_chapters_query(book_with_draft.draft), [])
    |> maybe_create_default_product_and_publish_multi(book)
    |> Repo.transaction()
    |> case do
      {:ok, %{book: published_book}} -> {:ok, published_book}
    end
  end

  def maybe_insert_readable_asset(repo, _previous_data, book) do
    case Assets.get_readable_asset_of_book(book) do
      nil ->
        Assets.readable_asset_changeset(book)
        |> repo.insert()

      asset ->
        {:ok, asset}
    end
  end

  def maybe_insert_default_product(
        repo,
        %{default_readable_asset: readable_asset},
        %Books.Book{status: :pending_publication} = book
      ) do
    Products.default_read_online_product_changeset(book, readable_asset)
    |> repo.insert()
  end

  def maybe_insert_default_product(_repo, _previous_data, _book) do
    {:ok, nil}
  end

  def publish_serial_chapter!(
        book,
        chapter,
        membership_tier_ids
      ) do
    chapter_result =
      if membership_tier_ids == ["free"] do
        Chapters.publish_free_serial_chapter(chapter)
      else
        Chapters.publish_serial_chapter(chapter, membership_tier_ids)
      end

    with {:ok, _published_chapter} <- chapter_result,
         {:ok, published_book} <- Books.publish_book(book) do
      published_book
    end
  end

  def publish_pre_order_chapter!(book, chapter) do
    {:ok, book} =
      Multi.new()
      |> Multi.update(:chapter, Chapters.free_chapter_changeset(chapter))
      |> maybe_create_default_product_and_publish_multi(book)
      |> Repo.transaction()
      |> case do
        {:ok, %{book: published_book}} -> {:ok, published_book}
      end

    book
  end
end
