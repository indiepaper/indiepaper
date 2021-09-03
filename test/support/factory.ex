defmodule IndiePaper.Factory do
  use ExMachina.Ecto, repo: IndiePaper.Repo

  def draft_factory do
    %IndiePaper.Drafts.Draft{
      title: sequence(:title, &"Draft Title #{&1}")
    }
  end
end
