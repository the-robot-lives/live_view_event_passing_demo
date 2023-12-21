defmodule LiveViewEventPassingDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveViewEventPassingDemoWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:live_view_event_passing_demo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveViewEventPassingDemo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveViewEventPassingDemo.Finch},
      # Start a worker by calling: LiveViewEventPassingDemo.Worker.start_link(arg)
      # {LiveViewEventPassingDemo.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveViewEventPassingDemoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveViewEventPassingDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveViewEventPassingDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
