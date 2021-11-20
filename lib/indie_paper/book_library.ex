defmodule IndiePaper.BookLibrary do
  alias IndiePaper.Orders

  def get_orders(customer) do
    Orders.list_orders(customer)
    |> load_order_assoc()
  end

  def list_payment_completed_orders(customer) do
    Orders.list_payment_completed_orders(customer)
    |> load_order_assoc()
  end

  defp load_order_assoc(orders),
    do: orders |> Orders.with_assoc([[book: :author], [line_items: [product: :assets]]])
end
