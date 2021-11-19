defmodule IndiePaperWeb.ConnCaseHelpers do
  @doc """
  Setup helper that registers and logs in authors.

      setup :register_and_log_in_author

  It stores an updated connection and a registered author in the
  test context.
  """
  def register_and_log_in_author(%{conn: conn}) do
    author = IndiePaper.AuthorsFixtures.author_fixture(:author)
    %{conn: log_in_author(conn, author), author: author}
  end

  @doc """
  Logs the given `author` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_author(conn, author) do
    token = IndiePaper.Authors.generate_author_session_token(author)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:author_token, token)
  end
end
