defmodule IndiePaper.Publication do
  alias Ecto.Multi
  alias IndiePaper.Repo
  alias IndiePaper.{Books, Chapters, Products}

  def publish_book(%Books.Book{} = book) do
    book_with_draft = book |> Books.with_assoc(:draft)

    Multi.new()
    |> Multi.update_all(:chapters, Chapters.publish_chapters_query(book_with_draft.draft), [])
    |> Multi.update(:book, Books.publish_book_changeset(book))
    |> Multi.run(
      :default_product,
      &maybe_insert_default_product(&1, &2, book)
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{book: published_book}} -> {:ok, published_book}
    end
  end

  def maybe_insert_default_product(
        repo,
        _previous_data,
        %Books.Book{status: :pending_publication} = book
      ) do
    Products.default_read_online_product_changeset(book)
    |> repo.insert()
  end

  def maybe_insert_default_product(_repo, _previous_data, _book) do
    {:ok, nil}
  end
end
