defmodule IndiePaperWeb.Pages.ProductPage.New do
  use IndiePaperWeb.PageHelpers

  def fill_form(session, params) do
    session
    |> fill_in(text_field("Title"), with: params[:title])
    |> fill_in(text_field("Description"), with: params[:description])
    |> fill_in(text_field("Price"), with: params[:price].amount)
  end

  def click_add_product(session) do
    session
    |> click(button("Add Product"))
  end
end
