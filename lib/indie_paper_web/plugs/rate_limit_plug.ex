defmodule IndiePaperWeb.Plugs.RateLimitPlug do
  import Plug.Conn, only: [halt: 1]

  alias IndiePaperWeb.Router.Helpers, as: Routes

  def rate_limit(conn, opts \\ []) do
    case check_rate(conn, opts) do
      {:ok, _count} -> conn
      {:error, _count} -> render_error(conn)
    end
  end

  defp check_rate(conn, opts) do
    interval_milliseconds = opts[:interval_seconds] * 1000
    max_requests = opts[:max_requests]
    ExRated.check_rate(bucket_name(conn), interval_milliseconds, max_requests)
  end

  # Bucket name should be a combination of ip address and request path, like so:
  #
  # "127.0.0.1:/api/v1/authorizations"
  defp bucket_name(conn) do
    path = Enum.join(conn.path_info, "/")
    ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")
    "#{ip}:#{path}"
  end

  defp render_error(conn) do
    conn
    |> Phoenix.Controller.put_flash(
      :error,
      "Request failed, you have exceeded maximum number requests. Please try again after one hour."
    )
    |> Phoenix.Controller.redirect(to: Routes.page_path(conn, :index))
    # Stop execution of further plugs, return response now
    |> halt()
  end
end
