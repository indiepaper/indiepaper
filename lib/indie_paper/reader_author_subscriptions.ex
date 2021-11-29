defmodule IndiePaper.ReaderAuthorSubscriptions do
  alias IndiePaper.Repo
  alias IndiePaper.ReaderAuthorSubscriptions.ReaderAuthorSubscription

  alias IndiePaper.Authors
  alias IndiePaper.MembershipTiers

  def create_reader_author_subscription!(params) do
    %ReaderAuthorSubscription{}
    |> ReaderAuthorSubscription.changeset(params)
    |> Repo.insert!()
  end
end
