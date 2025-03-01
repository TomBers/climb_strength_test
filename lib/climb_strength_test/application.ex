defmodule ClimbStrengthTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ClimbStrengthTestWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:climb_strength_test, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ClimbStrengthTest.PubSub},
      # Start a worker by calling: ClimbStrengthTest.Worker.start_link(arg)
      # {ClimbStrengthTest.Worker, arg},
      # Start to serve requests, typically the last entry
      ClimbStrengthTestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClimbStrengthTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClimbStrengthTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
