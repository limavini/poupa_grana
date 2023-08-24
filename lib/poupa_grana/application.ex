defmodule PoupaGrana.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PoupaGranaWeb.Telemetry,
      # Start the Ecto repository
      PoupaGrana.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PoupaGrana.PubSub},
      # Start Finch
      {Finch, name: PoupaGrana.Finch},
      # Start the Endpoint (http/https)
      PoupaGranaWeb.Endpoint
      # Start a worker by calling: PoupaGrana.Worker.start_link(arg)
      # {PoupaGrana.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PoupaGrana.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PoupaGranaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
