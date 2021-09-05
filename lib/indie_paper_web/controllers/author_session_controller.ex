defmodule IndiePaperWeb.AuthorSessionController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Authors
  alias IndiePaperWeb.AuthorAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"author" => author_params}) do
    %{"email" => email, "password" => password} = author_params

    if author = Authors.get_author_by_email_and_password(email, password) do
      AuthorAuth.log_in_author(conn, author, author_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> AuthorAuth.log_out_author()
  end
end
