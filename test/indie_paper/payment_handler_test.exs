defmodule IndiePaper.PaymentHandlerTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.PaymentHandler

  describe "get_stripe_connect_url/2" do
    test "set stripe connect id and get stripe connect url" do
      author = insert(:author, stripe_connect_id: nil)

      {:ok, stripe_connect_url} = PaymentHandler.get_stripe_connect_url(author, "US")

      stripe_connect_uri = URI.parse(stripe_connect_url)

      assert stripe_connect_uri.host == "stripe.com"
    end
  end
end
