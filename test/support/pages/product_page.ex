defmodule IndiePaperWeb.Pages.ProductPage do
  use IndiePaperWeb.PageHelpers

  def fill_form(session, params) do
    session
    |> fill_in(text_field("Title"), with: params[:title])
    |> fill_in(text_field("Description"), with: params[:description])
    |> fill_in(text_field("Price"), with: Decimal.to_string(Money.to_decimal(params[:price])))
  end

  def click_save_product(session) do
    session
    |> click(button("Save Product"))
  end
end
