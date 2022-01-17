defmodule IndiePaper.Workers.TypesetWorker do
  use Oban.Worker, queue: :typeset

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => book_id}}) do
    IO.inspect("Worker Working, #{book_id}")
    :ok
  end
end
