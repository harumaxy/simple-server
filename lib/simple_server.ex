defmodule SimpleServer do
  @behaviour Plug

  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    try do
      conn |> parse_query() |> auth() |> set_content_type("text/plain") |> route()
    catch
      :unauthorized -> conn |> send_resp(401, "Unauthorized")
    end
  end

  def parse_query(conn, _opts \\ []) do
    queries = conn.query_string |> URI.decode_query()
    conn |> assign(:queries, queries)
  end

  def auth(conn, _opts \\ []) do
    case conn.assigns[:queries] do
      %{"id" => "user", "password" => "password"} -> conn
      _ -> throw(:unauthorized)
    end
  end

  @spec set_content_type(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def set_content_type(conn, type) do
    conn |> put_resp_header("content-type", type)
  end

  def route(conn, _opts \\ []) do
    case {conn.method, conn.request_path} do
      {"GET", "/"} -> conn |> send_resp(200, "Hello, world!")
      {"GET", "/hello"} -> conn |> send_resp(200, "Hello, #{conn.assigns[:queries].id}!")
      _ -> conn |> send_resp(404, "Path not found")
    end
  end
end
