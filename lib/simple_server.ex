defmodule SimpleServer do
  use Plug.Router

  plug(:parse_query)
  plug(:auth)
  plug(:set_content_type, "text/plain")

  plug(:match)
  plug(:dispatch)

  def parse_query(conn, _opts \\ []) do
    queries = conn.query_string |> URI.decode_query()
    conn |> assign(:queries, queries)
  end

  def auth(conn, _opts \\ []) do
    case conn.assigns[:queries] do
      %{"id" => "user", "password" => "password"} -> conn
      _ -> conn |> send_resp(401, "Unauthorized") |> halt()
    end
  end

  def set_content_type(conn, type) do
    conn |> put_resp_header("content-type", type)
  end

  get "/" do
    IO.puts(conn.method)
    send_resp(conn, 200, "Hello, world!")
  end

  match _ do
    conn |> send_resp(404, "Path not found")
  end
end
