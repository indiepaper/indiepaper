defmodule IndiePaperWeb.Plugs.EnsureAccountStatusPlug do
  import Plug.Conn, only: [halt: 1]

  alias IndiePaperWeb.Router.Helpers, as: Routes

  alias IndiePaper.Authors.Author

  def init(config), do: config

  # Speicify status as from least to the major ones
  def call(conn, account_status_list) do
    conn
    |> IndiePaperWeb.AuthorAuth.fetch_current_author(%{})
    |> get_current_author()
    |> has_account_status?(account_status_list)
    |> maybe_halt(conn, account_status_list)
  end

  defp get_current_author(conn), do: conn.assigns.current_author

  defp has_account_status?(nil, _status_list), do: false

  defp has_account_status?(author, status_list) when is_list(status_list),
    do: Enum.any?(status_list, &has_account_status?(author, &1))

  defp has_account_status?(
         %Author{account_status: status},
         status
       ),
       do: true

  defp has_account_status?(_conn, _status), do: false

  defp maybe_halt(true, conn, _), do: conn

  defp maybe_halt(_any, conn, [:payment_connected | _]),
    do:
      redirect(
        conn,
        Routes.profile_stripe_connect_path(conn, :new),
        "Connect with your Stripe Account to Publish and start recieving payments"
      )

  defp maybe_halt(_any, conn, [:confirmed | _]),
    do:
      redirect(
        conn,
        Routes.dashboard_path(conn, :index),
        "Confirm your email address to continue"
      )

  defp redirect(conn, route, info_message) do
    conn
    |> Phoenix.Controller.put_flash(:info, info_message)
    |> Phoenix.Controller.redirect(to: route)
    |> halt()
  end
end
