defmodule IndiePaperWeb.PageController do
  use IndiePaperWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
