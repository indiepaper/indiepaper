defmodule IndiePaper.Orders do
  alias IndiePaper.Repo
  import Ecto.Query

  alias IndiePaper.Orders.{Order}

  def list_orders(%IndiePaper.Authors.Author{} = customer) do
    Order
    |> Bodyguard.scope(customer)
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def with_assoc(order, assoc) do
    order |> Repo.preload(assoc)
  end
end
