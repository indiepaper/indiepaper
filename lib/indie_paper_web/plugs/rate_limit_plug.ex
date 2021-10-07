defmodule IndiePaperWeb.Plugs.RateLimitPlug do
  import Plug.Conn, only: [halt: 1]

  alias IndiePaperWeb.Router.Helpers, as: Routes

  @rate_limit_enabled? Application.compile_env(:indie_paper, :rate_limit_plug_enabled, true)

  def rate_limit(conn, opts \\ []) do
    if @rate_limit_enabled? do
      case check_rate(conn, opts) do
        {:ok, _count} -> conn
        {:error, _count} -> render_error(conn, opts[:interval_seconds])
      end
    else
      conn
    end
  end

  defp check_rate(conn, options) do
    interval_milliseconds = options[:interval_seconds] * 1000
    max_requests = options[:max_requests]
    bucket_name = options[:bucket_name] || bucket_name(conn)

    ExRated.check_rate(bucket_name, interval_milliseconds, max_requests)
  end

  def rate_limit_authentication(conn, options \\ []) do
    options =
      Keyword.merge(options, bucket_name: "authentication:" <> conn.params["author"]["email"])

    rate_limit(conn, options)
  end

  def rate_limit_authenticated(conn, options \\ []) do
    options =
      Keyword.merge(options, bucket_name: "authenticated:" <> conn.assigns.current_author.email)

    rate_limit(conn, options)
  end

  # Bucket name should be a combination of ip address and request path, like so:
  #
  # "127.0.0.1:/api/v1/authorizations"
  defp bucket_name(conn) do
    path = Enum.join(conn.path_info, "/")
    ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")
    "#{ip}:#{path}"
  end

  defp render_error(conn, interval_seconds) do
    conn
    |> Phoenix.Controller.put_flash(
      :error,
      "Request failed, you have exceeded maximum number requests. Please try again after #{round(interval_seconds / (60 * 60))} hour(s)."
    )
    |> Phoenix.Controller.redirect(to: Routes.page_path(conn, :index))
    # Stop execution of further plugs, return response now
    |> halt()
  end
end
