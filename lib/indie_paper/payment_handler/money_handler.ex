defmodule IndiePaper.PaymentHandler.MoneyHandler do
  def to_string(%Money{} = money) do
    Money.to_string(money)
  end
end
