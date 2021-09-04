defmodule IndiePaper.Factory do
  use ExMachina.Ecto, repo: IndiePaper.Repo

  alias IndiePaper.Authors

  def draft_factory do
    %IndiePaper.Drafts.Draft{
      title: sequence(:title, &"Draft Title #{&1}"),
      chapters: [build(:draft_chapter)]
    }
  end

  def draft_chapter_factory do
    %IndiePaper.Drafts.Chapter{
      title: sequence(:title, &"Chapter Title #{&1}")
    }
  end

  def author_factory do
    %IndiePaper.Authors.Author{
      email: sequence(:email, &"author#{&1}@email.com")
    }
    |> Authors.Author.registration_changeset(%{password: "longpassword123"})
    |> Ecto.Changeset.put_change(:password, "longpassword123")
    |> Ecto.Changeset.apply_changes()
  end
end
