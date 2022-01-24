defmodule IndiePaper.Workers.TypesetWorkerTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Workers.TypesetWorker
  alias IndiePaper.Books
  alias IndiePaper.Assets

  @tag :skip
  test "typesets books to different formats and uploads to S3" do
    book = insert(:book, status: :publication_in_progress)

    assert :ok = perform_job(TypesetWorker, %{"id" => book.id})

    book = Books.get_book!(book.id)
    assets = Books.get_assets(book)

    assert Books.is_published?(book)
    assert Enum.find(assets, fn asset -> Assets.pdf?(asset) end)
  end
end
