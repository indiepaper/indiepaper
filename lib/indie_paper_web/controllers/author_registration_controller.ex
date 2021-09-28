defmodule IndiePaperWeb.AuthorRegistrationController do
  use IndiePaperWeb, :controller

  alias IndiePaper.Authors
  alias IndiePaper.Authors.Author
  alias IndiePaperWeb.AuthorAuth

  def new(conn, _params) do
    changeset = Authors.change_author_registration(%Author{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"author" => author_params}) do
    case Authors.register_author(author_params) do
      {:ok, author} ->
        {:ok, _} =
          Authors.deliver_author_confirmation_instructions(
            author,
            &Routes.author_confirmation_url(conn, :edit, &1)
          )

        conn
        |> AuthorAuth.log_in_author(author)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
