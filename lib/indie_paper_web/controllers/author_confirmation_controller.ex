defmodule IndiePaperWeb.AuthorConfirmationController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Authors

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"author" => %{"email" => email}}) do
    if author = Authors.get_author_by_email(email) do
      Authors.deliver_author_confirmation_instructions(
        author,
        &Routes.author_confirmation_url(conn, :edit, &1)
      )
    end

    # In order to prevent user enumeration attacks, regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "Confirmation Email has been sent, check for instructions"
    )
    |> redirect(
      to: if(conn.assigns.current_author, do: Routes.dashboard_path(conn, :index), else: "/")
    )
  end

  def edit(conn, %{"token" => token}) do
    render(conn, "edit.html", token: token)
  end

  # Do not log in the author after confirmation to avoid a
  # leaked token giving the author access to the account.
  def update(conn, %{"token" => token}) do
    case Authors.confirm_author(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Author confirmed successfully.")
        |> redirect(to: "/")

      :error ->
        # If there is a current author and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the author themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_author: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(:error, "Author confirmation link is invalid or it has expired.")
            |> redirect(to: "/")
        end
    end
  end
end
