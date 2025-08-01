defmodule WetterhaeckerWeb.Router do
  use WetterhaeckerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WetterhaeckerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/wetterhaecker", WetterhaeckerWeb do
    pipe_through :browser

    # get "/", PageController, :home
    live "/", MapsLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WetterhaeckerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:wetterhaecker, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/wetterhaecker/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WetterhaeckerWeb.Telemetry
    end
  end
end
