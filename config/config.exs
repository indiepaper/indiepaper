# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :indie_paper,
  ecto_repos: [IndiePaper.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :indie_paper, IndiePaperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Mw3VTjBpPQh4JECZcHQN/16zg8YP00SwCi05veapf9kqSRRX3W3RrNaPDCd7s1Mz",
  render_errors: [view: IndiePaperWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: IndiePaper.PubSub,
  live_view: [signing_salt: "1pAwMlMx"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :indie_paper, IndiePaper.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w( js/app.js js/draft_editor.js js/book_description_editor.js js/book_reader.js js/simple_tip_tap_html_editor.js
      --chunk-names=chunks/[name]-[hash] --splitting --format=esm --bundle --target=es2017
      --minify --outdir=../priv/static/assets
      --external:/fonts/* --external:/images/* ),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure Tailwind
config :tailwind,
  version: "3.0.10",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# MONEY
config :money,
  default_currency: :USD

# UEBERAUTH
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []},
    twitter: {Ueberauth.Strategy.Twitter, []}
  ]

# STRIPE_API
config :stripity_stripe,
  api_version: "2020-08-27"

# EX_AWS
config :ex_aws,
  debug_requests: true,
  json_codec: Jason

config :ex_aws, :s3,
  scheme: "https://",
  host: "nyc3.digitaloceanspaces.com",
  cdn_host: "nyc3.cdn.digitaloceanspaces.com",
  region: "nyc3"

# OBAN
config :indie_paper, Oban,
  repo: IndiePaper.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, typeset: 1]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
