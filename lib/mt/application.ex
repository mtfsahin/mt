defmodule Mt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MtWeb.Telemetry,
      Mt.Repo,
      {DNSCluster, query: Application.get_env(:mt, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mt.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Mt.Finch},
      # Start a worker by calling: Mt.Worker.start_link(arg)
      # {Mt.Worker, arg},
      # Start to serve requests, typically the last entry
      MtWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MtWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
