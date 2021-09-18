defmodule IndiePaperWeb.Plugs.EnsureAccountStatusPlug do
  import Plug.Conn, only: [halt: 1]

  alias IndiePaperWeb.Router.Helpers, as: Routes

  alias IndiePaper.Authors.Author

  def init(config), do: config

  def call(conn, account_status) do
    conn
    |> IndiePaperWeb.AuthorAuth.fetch_current_author(%{})
    |> has_account_status?(account_status)
    |> maybe_halt(conn, account_status)
  end

  defp has_account_status?(
         %{assigns: %{current_author: %Author{account_status: account_status}}},
         account_status
       ),
       do: true

  defp has_account_status?(
         _conn,
         _account_status
       ),
       do: false

  defp maybe_halt(true, conn, _), do: conn

  defp maybe_halt(_any, conn, :payment_connected),
    do:
      redirect(
        conn,
        Routes.profile_stripe_connect_path(conn, :new),
        "Connect with your Stripe Account to Publish and start recieving payments"
      )

  defp redirect(conn, route, info_message) do
    conn
    |> Phoenix.Controller.put_flash(:info, info_message)
    |> Phoenix.Controller.redirect(to: route)
    |> halt()
  end
end
