defmodule IndiePaper.Factory do
  use ExMachina.Ecto, repo: IndiePaper.Repo

  alias IndiePaper.Authors

  def draft_factory do
    %IndiePaper.Drafts.Draft{
      title: sequence(:title, &"Draft Title #{&1}"),
      chapters: [build(:chapter)],
      author: build(:author)
    }
  end

  def chapter_factory do
    %IndiePaper.Drafts.Chapter{
      title: sequence(:title, &"Chapter Title #{&1}")
    }
  end

  def author_factory do
    %IndiePaper.Authors.Author{
      email: sequence(:email, &"author#{&1}@email.com"),
      stripe_connect_id: sequence(:stripe_connect_id, &"acc_stripeacc#{&1}"),
      is_payment_connected: true
    }
    |> Authors.Author.registration_changeset(%{password: "longpassword123"})
    |> Ecto.Changeset.put_change(:password, "longpassword123")
    |> Ecto.Changeset.apply_changes()
  end
end
