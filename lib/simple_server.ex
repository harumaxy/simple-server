defmodule SimpleServer do
  @behaviour Plug

  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    conn |> send_resp(200, "Hello, world!")
  end
end
