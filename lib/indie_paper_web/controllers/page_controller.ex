defmodule IndiePaperWeb.PageController do
  use IndiePaperWeb, :controller

  def index(conn, _params) do
    meta_attrs = [
      %{name: "title", content: "IndiePaper, the best way to make and sell beautiful books"},
      %{
        name: "description",
        content:
          "IndiePaper is a place for authors to write, edit, publish and sell their books. Just write and we'll take care of the rest, taking your manuscript to beautiful self-published books to the hands of your readers."
      },
      %{name: "keywords", content: "tech blog, tech writing"},
      %{name: "description", content: "A tech blog by DevDecks"},
      %{name: "og:type", content: "website"},
      %{name: "og:url", content: "https://indiepaper.me/"},
      %{name: "og:title", content: "IndiePaper, the best way to make and sell beautiful books"},
      %{
        name: "og:description",
        content:
          "IndiePaper is a place for authors to write, edit, publish and sell their books. Just write and we'll take care of the rest, taking your manuscript to beautiful self-published books to the hands of your readers."
      },
      %{name: "og:image", content: Routes.static_url(conn, "/images/og-image.png")},
      %{name: "twitter:card", content: "summary_large_image"},
      %{name: "twitter:url", content: "https://indiepaper.me/"},
      %{
        name: "twitter:title",
        content: "IndiePaper, the best way to make and sell beautiful books"
      },
      %{
        name: "twitter:description",
        content:
          "IndiePaper is a place for authors to write, edit, publish and sell their books. Just write and we'll take care of the rest, taking your manuscript to beautiful self-published books to the hands of your readers."
      },
      %{name: "twitter:image", content: Routes.static_url(conn, "/images/og-image.png")}
    ]

    render(conn, "index.html",
      page_title: "IndiePaper, the best way to make and sell beautiful books",
      meta_attrs: meta_attrs
    )
  end

  def show(conn, %{"page" => "privacy-policy"}) do
    render(conn, "privacy-policy.html")
  end

  def show(conn, %{"page" => "terms-of-service"}) do
    render(conn, "terms-of-service.html")
  end
end
