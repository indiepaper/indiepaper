defmodule IndiePaperWeb.AuthorOauthController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Authors
  alias IndiePaperWeb.AuthorAuth

  plug Ueberauth

  @rand_pass_length 32

  def callback(%{assigns: %{ueberauth_auth: %{info: author_info}}} = conn, %{
        "provider" => "google"
      }) do
    conn
    |> register_or_sign_in_with_email(author_info.email, "Google")
  end

  def callback(%{assigns: %{ueberauth_auth: %{info: author_info}}} = conn, %{
        "provider" => "twitter"
      }) do
    conn
    |> register_or_sign_in_with_email(author_info.email, "Twitter")
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Authentication attempt with Social Provider failed. Please try again")
    |> redirect(to: Routes.author_registration_path(conn, :new))
  end

  defp register_or_sign_in_with_email(conn, email, provider) do
    author_params = %{email: email, password: random_password()}

    case Authors.fetch_or_create_author(author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Signed in to #{email} with #{provider}")
        |> AuthorAuth.log_in_author(author, %{"remember_me" => "true"})

      _ ->
        conn
        |> put_flash(:error, "Authentication Error")
        |> redirect(to: "/")
    end
  end

  defp random_password do
    :crypto.strong_rand_bytes(@rand_pass_length) |> Base.encode64()
  end
end
