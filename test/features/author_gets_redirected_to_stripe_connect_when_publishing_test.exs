defmodule IndiePaperWeb.AuthorGetsRedirectedToStripeConnectWhenPublishingTest do
  use IndiePaperWeb.FeatureCase, async: false

  alias IndiePaperWeb.Pages.{LoginPage, DashboardPage, DraftPage, StripeConnectPage}

  test "author gets redirected to Stripe Connect Page on Publish", %{session: session} do
    author = insert(:author, stripe_connect_id: nil, account_status: :confirmed)
    book = insert(:book, author: author, status: :pending_publication)

    session
    |> LoginPage.visit_page()
    |> LoginPage.login(email: book.author.email, password: book.author.password)
    |> DashboardPage.click_edit_draft()
    |> DraftPage.Edit.click_publish()
    |> StripeConnectPage.New.connect_stripe()
  end
end
