defmodule IndiePaperWeb.Feature.AuthorCanCreateSerialBooksTest do
  use IndiePaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "author can create serial books", %{conn: conn} do
    author = insert(:author)
    conn = log_in_author(conn, author)
    {:ok, view, _html} = live(conn, Routes.book_new_path(conn, :new))

    {:ok, conn} =
      view
      |> form("[data-test=new-book-form]",
        book: %{title: "Serial Novel"}
      )
      |> render_submit(%{book: %{"publishing_type" => "serial"}})
      |> follow_redirect(conn)

    html = html_response(conn, 200)

    assert html =~ "Serial Novel"
    assert html =~ "Publish Chapter"
  end

  test "author can publish single chapters", %{conn: conn} do
    author = insert(:author)
    conn = log_in_author(conn, author)
    chapter = insert(:chapter)
    membership_tier = insert(:membership_tier, author: author)

    book = insert(:book, publishing_type: :serial, draft: build(:draft, chapters: [chapter]))

    {:ok, view, _html} = live(conn, Routes.book_publish_chapter_path(conn, :new, book, chapter))

    {:ok, conn} =
      view
      |> form("[data-test=book-publish-chapter-form]",
        book: %{membership_tiers: [membership_tier.id]}
      )
      |> render_submit()
      |> follow_redirect(conn, to: Routes.book_path(conn, :show, book))

    html = html_response(conn, 200)

    assert html =~ book.title
  end
end
