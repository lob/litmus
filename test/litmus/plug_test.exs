defmodule Litmus.PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  describe "init/1" do
    test "returns input options" do
      assert Litmus.Plug.init([]) == []
    end
  end

  defmodule TestRouter do
    use Plug.Router

    plug(Plug.Parsers, parsers: [:urlencoded, :multipart])

    plug(:match)

    plug(Litmus.Plug, on_error: &__MODULE__.on_error/2)

    plug(:dispatch)

    @schema %{
      "id" => %Litmus.Type.Number{
        required: true
      }
    }

    get "/test", private: %{litmus_query: @schema} do
      Plug.Conn.send_resp(conn, 200, "items")
    end

    post "/test", private: %{litmus_body: @schema} do
      Plug.Conn.send_resp(conn, 200, "items")
    end

    def on_error(conn, error_message) do
      conn
      |> Plug.Conn.send_resp(400, error_message)
      |> Plug.Conn.halt()
    end
  end

  test "applies validation with valid query params" do
    conn =
      :get
      |> Plug.Test.conn("/test?id=123")
      |> TestRouter.call([])

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.query_params == %{"id" => 123}
  end

  test "calls the on_error function with invalid query params" do
    conn =
      :get
      |> Plug.Test.conn("/test?id=hello")
      |> TestRouter.call([])

    assert conn.state == :sent
    assert conn.status == 400
    assert conn.resp_body == "id must be a number"
  end

  test "applies validation with valid body params" do
    conn =
      :post
      |> Plug.Test.conn("/test", %{"id" => "123"})
      |> TestRouter.call([])

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.body_params == %{"id" => 123}
  end

  test "calls the on_error function with invalid body params" do
    conn =
      :post
      |> Plug.Test.conn("/test", %{"id" => "hello"})
      |> TestRouter.call([])

    assert conn.state == :sent
    assert conn.status == 400
    assert conn.resp_body == "id must be a number"
  end
end
