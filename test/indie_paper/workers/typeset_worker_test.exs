defmodule IndiePaper.Workers.TypesetWorkerTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.Workers.TypesetWorker

  test "typesets books to different formats and uploads to S3" do
    book = insert(:book)

    assert :ok = perform_job(TypesetWorker, %{"id" => book.id})
  end
end
