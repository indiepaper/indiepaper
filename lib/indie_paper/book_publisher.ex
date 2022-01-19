defmodule IndiePaper.BookPublisher do
  alias Ecto.Multi
  alias IndiePaper.Repo

  alias IndiePaper.Assets
  alias IndiePaper.Books
  alias IndiePaper.Chapters
  alias IndiePaper.Products
  alias IndiePaper.ChapterProducts

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
    |> Oban.insert(:typeset_book, fn %{book: published_book} ->
      IndiePaper.Workers.TypesetWorker.new(%{id: published_book.id})
    end)
  end

  def publish_book(%Books.Book{} = book) do
    book_with_draft = book |> Books.with_assoc(:draft)

    Multi.new()
    |> Multi.update_all(:chapters, Chapters.publish_chapters_query(book_with_draft.draft), [])
    |> maybe_create_default_product_and_publish_multi(book)
    |> Repo.transaction()
    |> case do
      {:ok, %{book: published_book}} ->
        {:ok, published_book}
    end
  end

  def maybe_insert_readable_asset(repo, _previous_data, book) do
    case Assets.get_readable_asset_of_book(book) do
      nil ->
        Assets.readable_asset_changeset(book, "Read online")
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
    Products.default_read_online_product_changeset(book, readable_asset, "Read online")
    |> repo.insert()
  end

  def maybe_insert_default_product(_repo, _previous_data, _book) do
    {:ok, nil}
  end

  def publish_pre_order_chapter!(book, chapter, nil) do
    {:ok, book} =
      Multi.new()
      |> Multi.update(:book, Books.publish_book_changeset(book))
      |> Multi.update(
        :chapter,
        Chapters.publish_free_chapter_changeset(chapter)
      )
      |> Multi.delete_all(:chapter_products, fn %{chapter: published_chapter} ->
        ChapterProducts.list_chapter_products_query(published_chapter)
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{book: published_book}} -> {:ok, published_book}
      end

    book
  end

  def publish_pre_order_chapter!(book, chapter, product_id) do
    {:ok, book} =
      Multi.new()
      |> Multi.update(:book, Books.publish_book_changeset(book))
      |> Multi.update(
        :chapter,
        Chapters.publish_chapter_changeset(chapter)
      )
      |> Multi.run(:chapter_product, fn repo, %{chapter: chapter} ->
        if is_nil(ChapterProducts.get_chapter_product(chapter.id, product_id)) do
          ChapterProducts.new_chapter_product(chapter.id, product_id)
          |> repo.insert()
        else
          {:ok, nil}
        end
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{book: published_book}} -> {:ok, published_book}
      end

    book
  end
end
