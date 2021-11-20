defmodule IndiePaperWeb.Feature.ReaderCanVisitAndBuyBookTest do
  use IndiePaperWeb.FeatureCase

  alias IndiePaperWeb.Pages.{BookPage, LoginPage, DashboardLibraryPage, AuthorPage}

  test "reader can visit book page and buy book", %{session: session} do
    book = insert(:book)
    customer = insert(:author)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: customer.email, password: customer.password)
    |> BookPage.Show.visit_page(book)
    |> BookPage.Show.has_buy_button?()

    # There is an issue with Stripe Mock, so for the time being we are going call the payment handler function by ourselves
    {:ok, _} = IndiePaper.PaymentHandler.get_checkout_session_url(customer, book)

    # Verify that an order is created
    session
    |> DashboardLibraryPage.visit_page()

    # |> DashboardLibraryPage.has_book_title?(book.title)
  end

  test "reader can read book if bought asset", %{session: session} do
    order = insert(:order, line_items: [build(:line_item)])
    chapter = Enum.at(order.book.draft.chapters, 0)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: order.customer.email, password: order.customer.password)
    |> DashboardLibraryPage.visit_page()
    |> DashboardLibraryPage.click_read_online()
    |> BookPage.Read.has_book_title?(order.book.title)
    |> BookPage.Read.has_chapter_title?(chapter.title)
  end

  test "reader cannot buy own book", %{session: session} do
    book = insert(:book)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: book.author.email, password: book.author.password)
    |> BookPage.Show.visit_page(book)
    |> BookPage.Show.click_buy_button()
    |> BookPage.Show.has_blocked_message?()
  end

  test "reader can see more books by the author", %{session: session} do
    book = insert(:book)
    customer = insert(:author)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: customer.email, password: customer.password)
    |> BookPage.Show.visit_page(book)
    |> BookPage.Show.click_author_name?(book.author.first_name)
    |> AuthorPage.Show.has_book_title?(book.title)
  end
end
