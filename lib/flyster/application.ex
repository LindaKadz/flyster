defmodule Flyster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FlysterWeb.Telemetry,
      # Start the Ecto repository
      Flyster.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Flyster.PubSub},
      # Start Finch
      {Finch, name: Flyster.Finch},
      # Start the Endpoint (http/https)
      FlysterWeb.Endpoint
      # Start a worker by calling: Flyster.Worker.start_link(arg)
      # {Flyster.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Logger.add_backend(Sentry.LoggerBackend)
    opts = [strategy: :one_for_one, name: Flyster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlysterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
