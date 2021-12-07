defmodule IndiePaper.Factory do
  use ExMachina.Ecto, repo: IndiePaper.Repo

  alias IndiePaper.Authors
  alias IndiePaper.Chapters

  def book_factory do
    %IndiePaper.Books.Book{
      title: sequence("Book Title"),
      publishing_type: :vanilla,
      short_description: "Really long and short description",
      long_description_html:
        "<h3>Book Description Html</h3><p>This is the description of the description</p>",
      draft: build(:draft),
      author: build(:author),
      status: :published,
      products: [build(:product), build(:product)],
      assets: [build(:asset, title: "Read online")]
    }
  end

  def asset_factory do
    %IndiePaper.Assets.Asset{
      type: :readable,
      title: sequence("Asset Title")
    }
  end

  def line_item_factory do
    %IndiePaper.Orders.LineItem{
      amount: Money.new(500),
      product: build(:product)
    }
  end

  def order_factory do
    %IndiePaper.Orders.Order{
      line_items: [build(:line_item), build(:line_item)],
      book: build(:book),
      customer: build(:author),
      status: :payment_completed,
      stripe_checkout_session_id: "checkout_session_id",
      amount: Money.new(420)
    }
  end

  def product_factory do
    %IndiePaper.Products.Product{
      title: sequence("Product Title"),
      description: sequence("Short description about Product"),
      price: Money.new(400),
      assets: [build(:asset, title: "Read online")]
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
      is_free: false,
      published_content_json:
        sequence(
          :published_content_json,
          fn num ->
            Chapters.placeholder_content_json(
              "Published Chapter Title #{num}",
              "PUblished Long Content"
            )
          end,
          start_at: 0
        ),
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
      username: sequence("author"),
      email: sequence(:email, &"author#{&1}@email.com"),
      first_name: sequence("First name"),
      last_name: sequence("Last name"),
      stripe_connect_id: sequence(:stripe_connect_id, &"acc_stripeacc#{&1}"),
      is_payment_connected: true,
      account_status: :payment_connected
    }
    |> Authors.Author.registration_changeset(%{password: "longpassword123"})
    |> Ecto.Changeset.put_change(:password, "longpassword123")
    |> Ecto.Changeset.apply_changes()
  end

  def membership_tier_factory do
    %IndiePaper.MembershipTiers.MembershipTier{
      title: sequence("Tier"),
      description_html:
        "<p>Description about the membership that makes everything worthwhile.</p>",
      author: build(:author),
      amount: Money.new(400),
      stripe_price_id: sequence("stripe_price_"),
      stripe_product_id: sequence("stripe_product")
    }
  end

  def reader_author_subscription_factory do
    author = build(:author)

    %IndiePaper.ReaderAuthorSubscriptions.ReaderAuthorSubscription{
      author: author,
      reader: build(:author),
      membership_tier: build(:membership_tier, author: author),
      status: :active,
      stripe_checkout_session_id: sequence("stripe_checkout_session_id")
    }
  end

  def chapter_membership_tier_factory do
    %IndiePaper.ChapterMembershipTiers.ChapterMembershipTier{
      chapter: build(:chapter),
      membership_tier: build(:membership_tier)
    }
  end

  def reader_book_subscription_factory do
    %IndiePaper.ReaderBookSubscriptions.ReaderBookSubscription{
      reader: build(:reader),
      book: build(:book, pubishing_type: :serial)
    }
  end
end
