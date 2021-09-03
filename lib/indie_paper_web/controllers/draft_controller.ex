defmodule IndiePaperWeb.DraftController do
  use IndiePaperWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end
end
