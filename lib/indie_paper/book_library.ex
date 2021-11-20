defmodule IndiePaper.BookLibrary do
  alias IndiePaper.Orders

  def get_orders(customer) do
    Orders.list_orders(customer)
    |> Orders.with_assoc([:book, [line_items: [product: :assets]]])
  end

  def list_payment_completed_orders(customer) do
    Orders.list_payment_completed_orders(customer)
    |> Orders.with_assoc([:book, [line_items: [product: :assets]]])
  end
end
