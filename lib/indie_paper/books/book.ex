defmodule IndiePaper.Books.Book do
  @behaviour Bodyguard.Schema
  import Ecto.Query, only: [from: 2]

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "books" do
    field :title, :string

    field :status, Ecto.Enum,
      values: [
        :pending_publication,
        :publication_in_progress,
        :published,
        :delisted,
        :removed
      ],
      default: :pending_publication,
      nil: false

    field :publishing_type, Ecto.Enum,
      values: [
        :vanilla,
        :pre_order
      ],
      default: :pre_order,
      nil: false

    field :short_description, :string
    field :long_description_html, :string
    field :cover_image, :string, nil: false, default: "public/cover_images/placeholder.png"

    has_one :draft, IndiePaper.Drafts.Draft
    has_many :products, IndiePaper.Products.Product, preload_order: [desc: :updated_at]
    has_many :assets, IndiePaper.Assets.Asset, preload_order: [desc: :type]
    belongs_to :author, IndiePaper.Authors.Author

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :short_description, :long_description_html, :cover_image])
    |> sanitized_long_description_html()
    |> validate_required([:title, :short_description, :long_description_html])
    |> validate_length(:title, max: 100)
    |> validate_length(:short_description, max: 240)
    |> validate_length(:long_description_html, max: 1200 * 6)
  end

  def sanitized_long_description_html(changeset) do
    long_description_html = get_field(changeset, :long_description_html)
    change(changeset, long_description_html: HtmlSanitizeEx.markdown_html(long_description_html))
  end

  def initial_draft_changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :publishing_type])
    |> validate_required([:title, :publishing_type])
    |> unique_constraint(:title)
  end

  def status_changeset(book, attrs) do
    book
    |> cast(attrs, [:status])
  end

  def scope(query, %IndiePaper.Authors.Author{id: author_id}, _) do
    from p in query, where: p.author_id == ^author_id
  end

  def to_slug(id, title) do
    "#{Slug.slugify(title)}-#{id}"
  end
end

defimpl Phoenix.Param, for: IndiePaper.Books.Book do
  def to_param(%{id: id, title: title}) do
    IndiePaper.Books.Book.to_slug(id, title)
  end
end
