defmodule IndiePaper.PaymentHandler.StripeHandler do
  def stripe_connect_enabled_countries() do
    [{"United States", "US"}, {"Italy", "IT"}, {"India", "IN"}]
  end
end
