defmodule IndiePaper.ReaderAuthorSubscriptions do
  alias IndiePaper.Repo

  alias IndiePaper.ReaderAuthorSubscriptions.ReaderAuthorSubscription

  def create_reader_author_subscription!(params) do
    %ReaderAuthorSubscription{}
    |> ReaderAuthorSubscription.changeset(params)
    |> Repo.insert!()
  end
end
