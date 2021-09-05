defmodule IndiePaperWeb.FallbackController do
  use IndiePaperWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(IndiePaperWeb.ErrorView)
    |> render(:"403")
  end
end
