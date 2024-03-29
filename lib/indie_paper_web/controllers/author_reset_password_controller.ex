defmodule IndiePaperWeb.AuthorResetPasswordController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Authors

  plug :get_author_by_reset_password_token when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"author" => %{"email" => email}}) do
    if author = Authors.get_author_by_email(email) do
      Authors.deliver_author_reset_password_instructions(
        author,
        &Routes.author_reset_password_url(conn, :edit, &1)
      )
    end

    # In order to prevent user enumeration attacks, regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "If your email is in our system, you will receive instructions to reset your password shortly."
    )
    |> redirect(to: "/secure/sign-in")
  end

  def edit(conn, _params) do
    render(conn, "edit.html", changeset: Authors.change_author_password(conn.assigns.author))
  end

  # Do not log in the author after reset password to avoid a
  # leaked token giving the author access to the account.
  def update(conn, %{"author" => author_params}) do
    case Authors.reset_author_password(conn.assigns.author, author_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Password reset successfully.")
        |> redirect(to: Routes.author_session_path(conn, :new))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  defp get_author_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if author = Authors.get_author_by_reset_password_token(token) do
      conn |> assign(:author, author) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: "/secure/sign-in")
      |> halt()
    end
  end
end
