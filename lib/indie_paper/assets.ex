defmodule IndiePaper.Assets do
  import Ecto.Query, only: [from: 2]
  alias IndiePaper.Repo

  alias IndiePaper.Assets.Asset

  def get_readable_asset_of_book(book) do
    from(a in Asset, where: a.book_id == ^book.id and a.type == :readable) |> Repo.one()
  end

  def readable_asset_changeset(book, title) do
    Ecto.build_assoc(book, :assets)
    |> Asset.changeset(%{type: :readable, title: title})
  end
end
