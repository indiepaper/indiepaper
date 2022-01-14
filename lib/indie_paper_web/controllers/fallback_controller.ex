defmodule IndiePaperWeb.FallbackController do
  use IndiePaperWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_flash(
      :error,
      "You are not authorized to perform that action. Contact Support if you think it's an error."
    )
    |> redirect(to: "/secure/sign-in")
  end
end
