defmodule IndiePaperWeb.BookLive.Show do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Books
  alias IndiePaper.ExternalAssetHandler
  alias IndiePaper.PaymentHandler.MoneyHandler
  alias IndiePaper.Authors

  on_mount {IndiePaperWeb.AuthorAuthLive, :fetch_current_author}

  def mount(%{"slug" => book_slug}, _session, socket) do
    book =
      Books.get_book_from_slug!(book_slug)
      |> Books.with_assoc([:author, :draft, [products: :assets]])

    book_image_url =
      if Books.has_promo_images?(book) do
        ExternalAssetHandler.get_public_url(Books.first_promo_image(book))
      else
        Routes.book_show_url(socket, :show, book)
      end

    meta_attrs = [
      %{name: "title", content: book.title},
      %{
        name: "description",
        content: book.short_description
      },
      %{name: "keywords", content: "book"},
      %{name: "og:type", content: "website"},
      %{name: "og:url", content: book_image_url},
      %{name: "og:title", content: book.title},
      %{
        name: "og:description",
        content: book.short_description
      },
      %{name: "og:image", content: Routes.static_url(socket, "/images/og-image.png")},
      %{name: "twitter:card", content: "summary_large_image"},
      %{name: "twitter:url", content: book_image_url},
      %{
        name: "twitter:title",
        content: book.title
      },
      %{
        name: "twitter:description",
        content: book.short_description
      },
      %{name: "twitter:image", content: Routes.static_url(socket, "/images/og-image.png")}
    ]

    {:ok, socket |> assign(book: book, meta_attrs: meta_attrs, page_title: book.title)}
  end
end
