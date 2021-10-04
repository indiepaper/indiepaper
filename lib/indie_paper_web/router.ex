defmodule IndiePaperWeb.Router do
  use IndiePaperWeb, :router

  import IndiePaperWeb.AuthorAuth
  import IndiePaperWeb.Plugs.RateLimitPlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {IndiePaperWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_author
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :account_status_payment_connected do
    plug IndiePaperWeb.Plugs.EnsureAccountStatusPlug, [:payment_connected]
  end

  pipeline :account_status_confirmed do
    plug IndiePaperWeb.Plugs.EnsureAccountStatusPlug, [:confirmed, :payment_connected]
  end

  pipeline :generic_rate_limit_with_ip do
    plug :rate_limit,
      max_requests: 8,
      interval_seconds: 60 * 60
  end

  pipeline :authentication_rate_limit_with_email do
    plug :rate_limit,
      max_requests: 8,
      interval_seconds: 60 * 60

    plug :rate_limit_authentication,
      max_requests: 4,
      interval_seconds: 60 * 60
  end

  scope "/stripe/webhooks", IndiePaperWeb do
    post "/connect", StripeWebhookController, :connect
  end

  ## Authentication routes
  scope "/", IndiePaperWeb do
    pipe_through [:browser, :redirect_if_author_is_authenticated, :generic_rate_limit_with_ip]

    get "/auth/:provider", AuthorOauthController, :request
    get "/auth/:provider/callback", AuthorOauthController, :callback
  end

  scope "/", IndiePaperWeb do
    pipe_through [
      :browser,
      :redirect_if_author_is_authenticated,
      :authentication_rate_limit_with_email
    ]

    post "/secure/sign-up", AuthorRegistrationController, :create
    post "/secure/sign-in", AuthorSessionController, :create
    post "/secure/reset_password", AuthorResetPasswordController, :create
  end

  scope "/", IndiePaperWeb do
    pipe_through [:browser, :redirect_if_author_is_authenticated]

    get "/secure/sign-up", AuthorRegistrationController, :new
    get "/secure/sign-in", AuthorSessionController, :new
    get "/secure/reset_password", AuthorResetPasswordController, :new
    get "/secure/reset_password/:token", AuthorResetPasswordController, :edit
    put "/secure/reset_password/:token", AuthorResetPasswordController, :update
  end

  scope "/", IndiePaperWeb do
    pipe_through [:browser, :require_authenticated_author]

    get "/authors/settings", AuthorSettingsController, :edit
    put "/authors/settings", AuthorSettingsController, :update
    get "/authors/settings/confirm_email/:token", AuthorSettingsController, :confirm_email
  end

  scope "/", IndiePaperWeb do
    pipe_through [:browser]

    delete "/secure/log_out", AuthorSessionController, :delete
    get "/secure/confirm", AuthorConfirmationController, :new
    post "/secure/confirm", AuthorConfirmationController, :create
    get "/secure/confirm/:token", AuthorConfirmationController, :edit
    post "/secure/confirm/:token", AuthorConfirmationController, :update
  end

  # App Specific Routes
  scope "/", IndiePaperWeb do
    pipe_through [:browser, :require_authenticated_author, :account_status_payment_connected]

    resources "/books", BookController, only: [] do
      resources "/publication", PublicationController, only: [:create]
      resources "/products", ProductController, only: [:create, :edit, :update]
    end
  end

  scope "/", IndiePaperWeb do
    pipe_through [:browser, :require_authenticated_author, :account_status_confirmed]

    resources "/profile/stripe/connect", ProfileStripeConnectController,
      only: [:new, :create, :delete]
  end

  scope "/", IndiePaperWeb do
    pipe_through [:browser, :require_authenticated_author]

    resources "/books", BookController, only: [:new, :create, :edit, :update] do
      resources "/read", ReadController, only: [:index, :show]
      resources "/checkout", CheckoutController, only: [:new]
    end

    resources "/drafts", DraftController, only: [:edit] do
      resources "/chapters", DraftChapterController, only: [:new, :edit, :update, :create, :show]
    end

    resources "/dashboard", DashboardController, only: [:index]

    resources "/dashboard/orders", DashboardOrderController, only: [:index]
  end

  scope "/", IndiePaperWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/:page", PageController, :show

    resources "/books", BookController, only: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", IndiePaperWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/live_dashboard", metrics: IndiePaperWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
