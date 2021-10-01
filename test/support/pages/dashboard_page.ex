defmodule IndiePaperWeb.Pages.DashboardPage do
  use IndiePaperWeb.PageHelpers

  def visit_page(session) do
    session
    |> visit(Routes.dashboard_path(@endpoint, :index))
  end

  def click_preview(session) do
    session
    |> click(link("Preview"))
  end

  def has_title?(session) do
    session
    |> assert_has(data("test", "title", text: "Your Books"))
  end

  def has_book_title?(session, title) do
    session
    |> assert_has(data("test", "book-title", text: title))
  end

  def not_has_draft_title?(session, title) do
    session
    |> refute_has(data("test", "draft-title", text: title))
  end

  def click_edit_draft(session) do
    session
    |> click(link("Edit draft"))
  end

  def click_connect_stripe(session) do
    session
    |> click(link("Connect Stripe"))
  end

  def has_no_connect_stripe?(session) do
    session
    |> refute_has(link("Connect Stripe"))
  end

  def click_update_listing(session) do
    session
    |> click(link("Update listing"))
  end

  def book_has_pending_publication_status?(session) do
    session
    |> assert_has(data("test", "book-status", text: "Pending publication"))
  end

  def has_product_title?(session, title) do
    session
    |> assert_has(data("test", "product-title", text: title))
  end

  def has_product_price?(session, price) do
    session
    |> assert_has(data("test", "product-price", text: Money.to_string(price)))
  end

  def click_add_product(session) do
    session
    |> click(link("Add Product"))
  end

  def click_edit_product(session, title) do
    session
    |> click(data("test", "product-edit", text: title))
  end

  def click_resend_confirmation_email(session) do
    session
    |> click(link("Resend Confirmation Email"))
  end

  def has_confirmation_email_text?(session) do
    session
    |> assert_has(Wallaby.Query.text("Confirmation Email has been sent"))
  end

  def has_confirm_email_text?(session) do
    session
    |> assert_has(Wallaby.Query.text("Confirm your email address to continue"))
  end
end
