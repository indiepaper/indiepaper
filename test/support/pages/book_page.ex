defmodule IndiePaperWeb.Pages.BookPage.Read do
  use IndiePaperWeb.PageHelpers

  def has_book_title?(session, title) do
    session
    |> assert_has(data("test", "book-title", text: title))
  end

  def has_chapter_title?(session, title) do
    session
    |> assert_has(data("test", "book-chapter-title", text: title))
  end
end

defmodule IndiePaperWeb.Pages.BookPage.Show do
  use IndiePaperWeb.PageHelpers

  def visit_page(session, book) do
    session
    |> visit(Routes.book_show_path(@endpoint, :show, book))
  end

  def select_product(session, product_title) do
    session
    |> click(button(product_title))
  end

  def click_buy_button(session) do
    session
    |> click(link("Buy Now"))
  end

  def has_buy_button?(session) do
    session
    |> assert_has(link("Buy Now"))
  end

  def click_author_name?(session, name) do
    session
    |> click(link(name))
  end

  def has_book_title?(session, title) do
    session
    |> assert_has(data("test", "title", text: title))
  end

  def has_blocked_message?(session) do
    session
    |> assert_has(Wallaby.Query.text("cannot buy"))
  end
end

defmodule IndiePaperWeb.Pages.BookPage.Edit do
  use IndiePaperWeb.PageHelpers

  def has_book_title?(session, title) do
    session
    |> assert_has(Wallaby.Query.text(title))
  end

  def fill_form(session, attrs) do
    session
    |> fill_in(text_field("Title"), with: attrs[:title])
    |> fill_in(text_field("Short description"), with: attrs[:short_description])
    |> fill_in(css("[contenteditable='true']"), with: attrs[:long_description_html])
  end

  def click_update_listing(session) do
    session
    |> click(button("Update Listing"))
  end
end

defmodule IndiePaperWeb.Pages.BookPage.New do
  use IndiePaperWeb.PageHelpers

  def fill_form(session, params) do
    session
    |> fill_in(text_field("Title"), with: params[:title])
  end

  def submit_form(session) do
    session
    |> click(button("Create Book"))
  end
end
