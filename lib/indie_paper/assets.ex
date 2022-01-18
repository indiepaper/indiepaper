defmodule IndiePaper.Assets do
  import Ecto.Query

  alias IndiePaper.Repo
  alias IndiePaperWeb.Router.Helpers, as: Routes
  alias IndiePaperWeb.Endpoint

  alias IndiePaper.Assets.Asset
  alias IndiePaper.ExternalAssetHandler

  def get_asset_of_book_query(book), do: from(a in Asset, where: a.book_id == ^book.id)

  def get_readable_asset_of_book(book) do
    get_asset_of_book_query(book) |> where(type: :readable) |> Repo.one()
  end

  def readable_asset_changeset(book, title) do
    Ecto.build_assoc(book, :assets)
    |> Asset.changeset(%{type: :readable, title: title})
  end

  def get_pdf_asset_of_book(book) do
    get_asset_of_book_query(book) |> where(type: :pdf) |> Repo.one()
  end

  def create_or_get_pdf_asset!(book) do
    case get_pdf_asset_of_book(book) do
      nil ->
        asset =
          Asset.changeset(Ecto.build_assoc(book, :assets), %{type: :pdf, title: "PDF"})
          |> Repo.insert!()

        asset_with_url =
          Asset.changeset(asset, %{url: "private/assets/#{asset.id}/book.pdf"}) |> Repo.update!()

        asset_with_url

      pdf_asset ->
        pdf_asset
    end
  end

  def get_url_or_path(%{type: :readable} = asset) do
    book = get_book(asset)
    Routes.book_read_path(Endpoint, :index, book)
  end

  def get_url_or_path(%{type: _, url: url}), do: ExternalAssetHandler.get_private_url(url)

  def get_book(asset) do
    asset |> Repo.preload(:book) |> Map.get(:book)
  end

  def pdf?(%Asset{type: :pdf}), do: true
  def pdf?(_), do: false
end
