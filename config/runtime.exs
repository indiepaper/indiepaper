import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :indie_paper, IndiePaperWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :indie_paper, IndiePaper.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "indiepaper.me"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :indie_paper, IndiePaperWeb.Endpoint,
    url: [host: host, port: 443],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base,

  # Stripe Config
  config :stripity_stripe,
    api_key: System.get_env("STRIPE_API_SECRET"),
    connect_webhook_signing_secret: System.get_env("STRIPE_CONNECT_WEBHOOK_SIGNING_SECRET"),
    account_webhook_signing_secret: System.get_env("STRIPE_ACCOUNT_WEBHOOK_SIGNING_SECRET")

  # Setup AppSignal in production
  config :appsignal, :config,
    otp_app: :indie_paper,
    name: "IndiePaper",
    push_api_key: System.get_env("APPSIGNAL_PUSH_API_KEY"),
    env: System.get_env("INDIEPAPER_DEPLOY_ENV"),
    active: true

  # Setup UeberAuth Google
  config :ueberauth, Ueberauth.Strategy.Google.OAuth,
    client_id: System.get_env("UEBERAUTH_GOOGLE_CLIENT_ID"),
    client_secret: System.get_env("UEBERAUTH_GOOGLE_CLIENT_SECRET")

  config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
    consumer_key: System.get_env("UEBERAUTH_TWITTER_CONSUMER_KEY"),
    consumer_secret: System.get_env("UEBERAUTH_TWITTER_CONSUMER_SECRET")

  # Setup Swoosh with Postmark
  config :swoosh, local: false, api_client: Swoosh.ApiClient.Hackney

  config :indie_paper, IndiePaper.Mailer,
    adapter: Swoosh.Adapters.Postmark,
    api_key: System.get_env("SWOOSH_POSTMARK_API_KEY")

  # EXAWS Config
  config :ex_aws,
    access_key_id: System.get_env("SPACES_ACCESS_KEY_ID"),
    secret_access_key: System.get_env("SPACES_SECRET_ACCESS_KEY"),
    bucket_name: System.get_env("SPACES_BUCKET_NAME")

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :indie_paper, IndiePaperWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :indie_paper, IndiePaper.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
  #
end
