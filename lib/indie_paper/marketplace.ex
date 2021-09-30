defmodule IndiePaper.Marketplace do
  @behaviour Bodyguard.Policy
  import Ecto.Query, only: [from: 2]

  alias IndiePaper.Repo

  def authorize(:can_read, reader, book), do: has_reader_bought_book?(reader, book)
  def authorize(_, _, _), do: false

  def has_reader_bought_book?(reader, book) do
    {:ok, reader_id} = Ecto.UUID.dump(reader.id)
    {:ok, book_id} = Ecto.UUID.dump(book.id)

    from(o in "orders",
      where: o.customer_id == ^reader_id and o.book_id == ^book_id
    )
    |> Repo.aggregate(:count) > 0
  end
end
