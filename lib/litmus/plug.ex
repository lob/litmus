defmodule Litmus.Plug do
  @moduledoc false

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  def call(conn, opts) do
    conn = Plug.Conn.fetch_query_params(conn)

    with {:ok, conn} <- validate_query_params(conn),
         {:ok, conn} <- validate_body_params(conn) do
      conn
    else
      {:error, message} -> opts[:on_error].(conn, message)
    end
  end

  @spec validate_query_params(Plug.Conn.t()) :: {:ok, Plug.Conn.t()} | {:error, String.t()}
  def validate_query_params(conn = %Plug.Conn{private: %{litmus_query: schema}}) do
    case Litmus.validate(conn.query_params, schema) do
      {:ok, new_params} -> {:ok, %Plug.Conn{conn | query_params: new_params}}
      {:error, message} -> {:error, message}
    end
  end

  def validate_query_params(conn), do: {:ok, conn}

  @spec validate_body_params(Plug.Conn.t()) :: {:ok, Plug.Conn.t()} | {:error, String.t()}
  def validate_body_params(conn = %Plug.Conn{private: %{litmus_body: schema}}) do
    case Litmus.validate(conn.body_params, schema) do
      {:ok, new_params} -> {:ok, %Plug.Conn{conn | body_params: new_params}}
      {:error, message} -> {:error, message}
    end
  end

  def validate_body_params(conn), do: {:ok, conn}
end
