defmodule CspDashboardPhxWeb.Router do
  use CspDashboardPhxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CspDashboardPhxWeb.Layouts, :root}
    plug :put_secure_browser_headers,
         %{"content-security-policy-report-only" => "default-src 'self'; report-uri /violation_reports"}
  end

  pipeline :csrf do
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CspDashboardPhxWeb do
    pipe_through [:browser, :csrf]

    get "/", ViolationReportController, :index

    resources "/violation_reports", ViolationReportController, only: [:index, :show, :delete]
  end

  scope "/", CspDashboardPhxWeb do
    pipe_through :browser

    resources "/violation_reports", ViolationReportController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CspDashboardPhxWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:csp_dashboard_phx, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:browser, :csrf]

      live_dashboard "/dashboard", metrics: CspDashboardPhxWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
