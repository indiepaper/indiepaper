defmodule IndiePaper.ReaderBookSubscriptions do
  import Ecto.Query
  alias IndiePaper.Repo

  alias IndiePaper.ReaderBookSubscriptions.ReaderBookSubscription

  def create_reader_book_subscription(reader_id, book_id) do
    %ReaderBookSubscription{}
    |> ReaderBookSubscription.changeset(%{reader_id: reader_id, book_id: book_id})
    |> Repo.insert()
  end

  def list_book_subscriptions(reader_id) do
    from(rbs in ReaderBookSubscription, where: rbs.reader_id == ^reader_id)
    |> Repo.all()
  end

  def get_reader_book_subscription(reader_id, book_id) do
    from(rbs in ReaderBookSubscription,
      where: rbs.book_id == ^book_id and rbs.reader_id == ^reader_id
    )
    |> Repo.one()
  end

  def with_book(query) do
    query |> Repo.preload(:book)
  end
end
