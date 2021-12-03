defmodule IndiePaper.PaymentHandler.MoneyHandler do
  def humanize(%Money{} = money) do
    Money.to_string(money)
  end

  def add(m, addend), do: Money.add(m, addend)

  def calculate_percentage(money, percentage), do: Money.multiply(money, percentage / 100)

  def new(amount), do: Money.new(amount)
end
