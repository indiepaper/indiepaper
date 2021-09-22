defmodule IndiePaper.PaymentHandler.MoneyHandler do
  def humanize(%Money{} = money) do
    Money.to_string(money)
  end
end
