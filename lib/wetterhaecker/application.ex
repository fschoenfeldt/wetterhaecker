defmodule Wetterhaecker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Wetterhaecker.Encoder

  @impl true
  def start(_type, _args) do
    children = [
      WetterhaeckerWeb.Telemetry,
      Wetterhaecker.Repo,
      {Ecto.Migrator, repos: Application.fetch_env!(:wetterhaecker, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:wetterhaecker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Wetterhaecker.PubSub},
      # Start a worker by calling: Wetterhaecker.Worker.start_link(arg)
      # {Wetterhaecker.Worker, arg},
      # Start to serve requests, typically the last entry
      WetterhaeckerWeb.Endpoint,
      TwMerge.Cache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wetterhaecker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WetterhaeckerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations? do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
