defmodule IndiePaperWeb.AuthorAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias IndiePaper.Authors
  alias IndiePaperWeb.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in AuthorToken.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_indie_paper_web_author_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Logs the author in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_author(conn, author, params \\ %{}) do
    author_return_to = get_session(conn, :author_return_to)

    log_in_author_without_redirect(conn, author, params)
    |> redirect(to: author_return_to || signed_in_path(conn))
  end

  def log_in_author_without_redirect(conn, author, params \\ %{}) do
    token = Authors.generate_author_session_token(author)

    conn
    |> renew_session()
    |> put_session(:author_token, token)
    |> put_session(:live_socket_id, "authors_sessions:#{Base.url_encode64(token)}")
    |> maybe_write_remember_me_cookie(token, params)
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the author out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_author(conn) do
    author_token = get_session(conn, :author_token)
    author_token && Authors.delete_session_token(author_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      IndiePaperWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: "/")
  end

  @doc """
  Authenticates the author by looking into the session
  and remember me token.
  """
  def fetch_current_author(conn, _opts) do
    {author_token, conn} = ensure_author_token(conn)
    author = author_token && Authors.get_author_by_session_token(author_token)
    assign(conn, :current_author, author)
  end

  defp ensure_author_token(conn) do
    if author_token = get_session(conn, :author_token) do
      {author_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if author_token = conn.cookies[@remember_me_cookie] do
        {author_token, put_session(conn, :author_token, author_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Used for routes that require the author to not be authenticated.
  """
  def redirect_if_author_is_authenticated(conn, _opts) do
    if conn.assigns[:current_author] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the author to be authenticated.

  If you want to enforce the author email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_author(conn, _opts) do
    if conn.assigns[:current_author] do
      conn
    else
      conn
      |> put_flash(:info, "Create an account or Sign in to continue.")
      |> maybe_store_return_to()
      |> redirect(to: Routes.author_registration_path(conn, :new))
      |> halt()
    end
  end

  def store_return_to(conn, nil), do: conn

  def store_return_to(conn, return_to_path) do
    put_session(conn, :author_return_to, return_to_path)
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    store_return_to(conn, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  def signed_in_path(conn), do: Routes.dashboard_path(conn, :index)
end
