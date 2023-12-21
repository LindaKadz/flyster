defmodule FlysterWeb.Router do
  use FlysterWeb, :router

  import FlysterWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FlysterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FlysterWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/about", PageController, :about
  end

  # Other scopes may use custom stacks.
  # scope "/api", FlysterWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:flyster, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FlysterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", FlysterWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{FlysterWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", FlysterWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{FlysterWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      # user profile
      live "/users/:id/profile", ProfileShowLive, :show
      live "/users/:id/delete", UserProfileDeleteLive, :delete

      #events
      live "/events", EventsIndexLive, :index
      live "/events/new", EventsNewLive, :new
      live "/events/:id", EventsShowLive, :show
      live "/my/events", MyEventsIndexLive, :index
      live "/my/events/:id/edit", MyEventsEditLive, :edit
      live "/my/events/:id", MyEventsDeleteLive, :delete

      #goals
      live "/goals", GoalsIndexLive, :index
      live "/goals/new", GoalsNewLive, :new
      live "/my/goals", MyGoalsIndexLive, :index
      live "/my/goals/:id/mark_as_complete", MyGoalsEditLive, :edit
      live "/my/goals/:id", MyGoalsDeleteLive, :delete
      live "/my/goal_comment/:id", MyGoalCommentDeleteLive, :delete

      #challenges
      live "/challenges", ChallengesIndexLive, :index
      live "/challenges/new", ChallengesNewLive, :new
      live "/my/challenges", MyChallengesIndexLive, :index
      live "/my/challenges/:id", MyChallengesDeleteLive, :delete

      #feedback
      live "/feedback/new", NewFeedbackLive, :new
      live "/feedback", IndexFeedbackLive, :index
    end
  end

  scope "/", FlysterWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{FlysterWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
