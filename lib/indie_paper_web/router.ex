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

  pipeline :require_account_status_payment_connected do
    plug IndiePaperWeb.Plugs.EnsureAccountStatusPlug, [:payment_connected]
  end

  pipeline :require_account_status_confirmed do
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
      max_requests: 6,
      interval_seconds: 60 * 60
  end

  pipeline :stripe_connect_rate_limit do
    plug :rate_limit_authenticated,
      max_requests: 3,
      interval_seconds: 60 * 60 * 24
  end

  ## Authentication routes
  scope "/", IndiePaperWeb do
    pipe_through [:browser, :redirect_if_author_is_authenticated, :generic_rate_limit_with_ip]
  end

  scope "/", IndiePaperWeb do
    pipe_through [
      :browser,
      :redirect_if_author_is_authenticated,
      :authentication_rate_limit_with_email
    ]

    post "/secure/sign-up", AuthorRegistrationController, :create
    post "/secure/sign-in", AuthorSessionController, :create
    post "/secure/reset-password", AuthorResetPasswordController, :create
  end

  scope "/", IndiePaperWeb do
    pipe_through [:browser, :redirect_if_author_is_authenticated]

    get "/auth/:provider", AuthorOauthController, :request
    get "/auth/:provider/callback", AuthorOauthController, :callback

    get "/secure/sign-up", AuthorRegistrationController, :new
    get "/secure/sign-in", AuthorSessionController, :new
    get "/secure/reset-password", AuthorResetPasswordController, :new
    get "/secure/reset-password/:token", AuthorResetPasswordController, :edit
    put "/secure/reset-password/:token", AuthorResetPasswordController, :update
  end

  scope "/", IndiePaperWeb do
    pipe_through [:browser, :require_authenticated_author]

    live "/secure/finish", AuthorProfileSetupLive
    get "/settings", AuthorSettingsController, :edit
    put "/settings", AuthorSettingsController, :update
    get "/settings/confirm_email/:token", AuthorSettingsController, :confirm_email
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

  live_session :default do
    scope "/", IndiePaperWeb do
      pipe_through [
        :browser,
        :require_authenticated_author,
        :require_account_status_payment_connected
      ]

      live "/books/:book_slug/publish/:id", BookPublishChapterLive, :new

      resources "/books", BookController, only: [], param: "slug" do
        resources "/publication", PublicationController, only: [:create]
      end

      live "/dashboard/orders", DashboardOrdersLive, :index
    end

    scope "/", IndiePaperWeb do
      pipe_through [:browser, :require_authenticated_author, :require_account_status_confirmed]

      live "/profile/stripe/connect", ProfileStripeConnectLive, :new
    end

    scope "/", IndiePaperWeb do
      pipe_through [:browser, :require_authenticated_author]

      live "/books/new", BookLive.New, :new

      resources "/books", BookController, only: [], param: "slug" do
        resources "/checkout", CheckoutController, only: [:new]
      end

      live "/books/:slug/edit", BookLive.Edit, :edit

      live "/drafts/:id/edit", DraftLive.Edit, :edit

      live "/dashboard", DashboardLive, :index
      live "/dashboard/library", DashboardLibraryLive, :index
      live "/settings/profile", SettingsProfileLive, :edit
    end

    scope "/", IndiePaperWeb do
      pipe_through :browser

      resources "/books", BookController, only: [], param: "slug" do
        live "/read", ReadLive, :index
        resources "/products", ProductController, only: [:create, :edit, :update]
      end

      get "/", PageController, :index
      get "/privacy-policy", PageController, :privacy_policy
      get "/terms-of-service", PageController, :terms_of_service

      live "/books/:slug", BookLive.Show, :show
    end

    scope "/", IndiePaperWeb do
      pipe_through :browser

      live "/:username", AuthorPageLive, :show
    end
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
