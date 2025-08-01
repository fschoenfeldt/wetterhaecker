# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  wetterhaecker: [
    args:
      ~w(js/app.ts --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mime,
  types: %{
    "application/gpx+xml" => ["gpx"]
  }

# Use Jason for JSON parsing in Phoenix
#
config :phoenix, :json_library, Jason

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  wetterhaecker: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures the endpoint
config :wetterhaecker, WetterhaeckerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: WetterhaeckerWeb.ErrorHTML, json: WetterhaeckerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Wetterhaecker.PubSub,
  live_view: [signing_salt: "kXbCSxmh"],
  static_url: [path: "/wetterhaecker"]

config :wetterhaecker,
  ecto_repos: [Wetterhaecker.Repo],
  generators: [timestamp_type: :utc_datetime]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

import_config "#{config_env()}.exs"
