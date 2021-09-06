defmodule IndiePaperWeb.Plugs.StripeWebhookPlug do
  @behaviour Plug

  def init(config), do: config

  def call(%{request_path: "/stripe/webhooks"} = conn, _) do
    signing_secret = Application.get_env(:stripity_stripe, :connect_webhook_signing_secret)
    {:ok, body, _} = Plug.Conn.read_body(conn)
    [stripe_signature] = Plug.Conn.get_req_header(conn, "stripe-signature")

    {:ok, stripe_event} = Stripe.Webhook.construct_event(body, stripe_signature, signing_secret)

    Plug.Conn.assign(conn, :stripe_event, stripe_event)
  end

  def call(conn, _), do: conn
end
