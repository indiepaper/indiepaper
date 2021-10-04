defmodule IndiePaperWeb.PageController do
  use IndiePaperWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      page_title: "IndiePaper, the best way to make and sell beautiful books"
    )
  end

  def show(conn, %{"page" => "privacy-policy"}) do
    render(conn, "privacy-policy.html")
  end

  def show(conn, %{"page" => "terms-of-service"}) do
    render(conn, "terms-of-service.html")
  end
end
