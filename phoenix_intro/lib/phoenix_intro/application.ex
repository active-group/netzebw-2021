defmodule PhoenixIntro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PhoenixIntro.Repo,
      # Start the Telemetry supervisor
      PhoenixIntroWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixIntro.PubSub},
      # Start the Endpoint (http/https)
      PhoenixIntroWeb.Endpoint,
      # Start a worker by calling: PhoenixIntro.Worker.start_link(arg)
      # {PhoenixIntro.Worker, arg}
      {PhoenixIntro.UserStatusService, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixIntro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixIntroWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
