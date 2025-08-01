import Config

# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id],
#   truncate: :infinity

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :oapi_generator,
  brightsky: [
    output: [
      base_module: Wetterhaecker.Weather.Brightsky,
      location: "lib/wetterhaecker/weather/brightsky",
      operation_subdirectory: "operations/",
      schema_subdirectory: "schemas/"
    ]
  ]

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

config :phoenix_live_view,
  # Include HEEx debug annotations as HTML comments in rendered markup
  debug_heex_annotations: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

config :salad_ui, components_path: Path.join(File.cwd!(), "lib/wetterhaecker_web/components")

# Configure your database
config :wetterhaecker, Wetterhaecker.Repo,
  database: Path.expand("../wetterhaecker_dev.db", __DIR__),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :wetterhaecker, WetterhaeckerWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "/8mPkSfkp7mtU1aJ0naUn81G5f32AynVbZs5llzHSxcLm7Z+LsHEGh+Zdee9yvTV",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:wetterhaecker, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:wetterhaecker, ~w(--watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.
# Watch static and templates for browser reloading.
config :wetterhaecker, WetterhaeckerWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/wetterhaecker_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :wetterhaecker, dev_routes: true
