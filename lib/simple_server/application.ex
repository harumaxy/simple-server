defmodule SimpleServer.Application do
  require Logger
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: SimpleServer, port: 4000}
    ]

    opts = [strategy: :one_for_one, name: SimpleServer.Supervisor]
    Logger.info("server listening on http://localhost:4000")
    Supervisor.start_link(children, opts)
  end
end
