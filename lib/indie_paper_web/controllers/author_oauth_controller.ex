defmodule IndiePaperWeb.AuthorOauthController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Authors
  alias IndiePaperWeb.AuthorAuth

  plug Ueberauth

  @rand_pass_length 32

  def callback(%{assigns: %{ueberauth_auth: %{info: author_info}}} = conn, %{
        "provider" => "google"
      }) do
    author_params = %{email: author_info.email, password: random_password()}

    case Authors.fetch_or_create_author(author_params) do
      {:ok, author} ->
        AuthorAuth.log_in_author(conn, author)

      _ ->
        conn
        |> put_flash(:error, "Authentication Error")
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed")
    |> redirect(to: "/")
  end

  defp random_password do
    :crypto.strong_rand_bytes(@rand_pass_length) |> Base.encode64()
  end
end
