defmodule IndiePaper.Factory do
  use ExMachina.Ecto, repo: IndiePaper.Repo

  alias IndiePaper.Authors
  alias IndiePaper.Chapters

  def book_factory do
    %IndiePaper.Books.Book{
      title: sequence("Book Title"),
      short_description: "Really long and short description",
      long_description_html:
        "<h3>Book Description Html</h3><p>This is the description of the description</p>",
      draft: build(:draft),
      author: build(:author),
      status: :published
    }
  end

  def draft_factory do
    %IndiePaper.Drafts.Draft{
      chapters: [build(:chapter), build(:chapter)]
    }
  end

  def chapter_factory do
    %IndiePaper.Chapters.Chapter{
      title: sequence(:title, &"Chapter Title #{&1}", start_at: 0),
      chapter_index: sequence(:chapter_index, fn num -> num end, start_at: 0),
      content_json:
        sequence(
          :content_json,
          fn num ->
            Chapters.placeholder_content_json("Chapter Title #{num}", "Long Content")
          end,
          start_at: 0
        )
    }
  end

  def author_factory do
    %IndiePaper.Authors.Author{
      email: sequence(:email, &"author#{&1}@email.com"),
      stripe_connect_id: sequence(:stripe_connect_id, &"acc_stripeacc#{&1}"),
      is_payment_connected: true,
      account_status: :payment_connected
    }
    |> Authors.Author.registration_changeset(%{password: "longpassword123"})
    |> Ecto.Changeset.put_change(:password, "longpassword123")
    |> Ecto.Changeset.apply_changes()
  end
end
