defmodule IndiePaperWeb.DashboardOrdersLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorAuthLive
end
