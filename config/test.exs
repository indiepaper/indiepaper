import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :indie_paper, IndiePaper.Repo,
  username: "postgres",
  password: "postgres",
  database: "indie_paper_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :indie_paper, IndiePaperWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: true

# Setup Ecto Sandbox in tests
config :indie_paper, :sql_sandbox, true

# In test we don't send emails.
config :indie_paper, IndiePaper.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Setup Wallaby to use Chrome
config :wallaby, driver: Wallaby.Chrome
