defmodule IndiePaper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      IndiePaper.Repo,
      # Start the Telemetry supervisor
      IndiePaperWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: IndiePaper.PubSub},
      # Start the Endpoint (http/https)
      IndiePaperWeb.Endpoint,
      # OBAN
      {Oban, oban_config()}
      # Start a worker by calling: IndiePaper.Worker.start_link(arg)
      # {IndiePaper.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IndiePaper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IndiePaperWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:indie_paper, Oban)
  end
end
