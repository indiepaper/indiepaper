defmodule IndiePaper.Repo do
  use Ecto.Repo,
    otp_app: :indie_paper,
    adapter: Ecto.Adapters.Postgres
end
