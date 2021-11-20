defmodule IndiePaperWeb.SettingsProfileLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth
end
