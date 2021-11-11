defmodule IndiePaper.MixProject do
  use Mix.Project

  def project do
    [
      app: :indie_paper,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: releases()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {IndiePaper.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 2.0"},
      {:phoenix, "~> 1.6.0-rc.0", override: true},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.16.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:hackney, "~> 1.17"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:wallaby, "~> 0.28.0", [runtime: false, only: :test]},
      {:tesla, "~> 1.4", override: true},
      {:ex_machina, "~> 2.7", only: :test},
      {:bodyguard, "~> 2.4"},
      {:appsignal, "~> 2.0"},
      {:stripity_stripe, "~> 2.0"},
      {:money, "~> 1.4"},
      {:ueberauth, "~> 0.6"},
      {:ueberauth_google, "~> 0.10"},
      {:ueberauth_twitter, "~> 0.4"},
      {:html_sanitize_ex, "~> 1.4"},
      {:ex_rated, "~> 2.0"},
      {:json_patch, "~> 0.8.0"},
      {:exjsonpath, "~> 0.1"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, git: "https://github.com/ex-aws/ex_aws_s3", branch: "main"},
      {:sweet_xml, "~> 0.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd --cd assets npm install"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test --max-cases=2"],
      "assets.deploy": [
        "cmd --cd assets npm run deploy",
        "esbuild default --minify",
        "phx.digest"
      ]
    ]
  end

  defp releases do
    [
      indie_paper: [
        include_executables_for: [:unix],
        cookie: "7LByVvfN4jjQ4yN49USEyzGGfe-wRqDy_wh4VrwZeWwEfST5P2GvMw=="
      ]
    ]
  end
end
