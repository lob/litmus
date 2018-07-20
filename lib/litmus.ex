defmodule Litmus do
  @moduledoc """
  Documentation for Litmus. Validate data against schema defined.

  ## Examples

      iex> schema = %{"id": %Litmus.Type.Any{"required": true}}
      iex> params = %{"id": 1}
      iex> Litmus.validate(params, schema)
      {:ok, %{id: 1}}

      iex> schema = %{"id": %Litmus.Type.Any{}}
      iex> params = %{"password": 1}
      iex> Litmus.validate(params, schema)
      {:error, "password is not allowed"}

  """

  alias Litmus.Type

  @doc """
  Validate data based on a schema.
  """
  @spec validate(map, map) :: {:ok, map} | {:error, String.t()}
  def validate(data, schema) do
    case validate_allowed_params(data, schema) do
      :ok -> validate_schema(data, schema)
      error = {:error, _} -> error
    end
  end

  @spec validate_allowed_params(map, map) :: :ok | {:error, String.t()}
  defp validate_allowed_params(data, schema) do
    result = Map.keys(data) -- Map.keys(schema)

    case result do
      [] -> :ok
      [field | _rest] -> {:error, "#{field} is not allowed"}
    end
  end

  @spec validate_schema(map, map) :: {:ok, map} | {:error, String.t()}
  def validate_schema(data, schema) do
    Enum.reduce_while(schema, data, fn {field, type}, modified_data ->
      case Type.validate(type, field, modified_data) do
        {:error, msg} ->
          {:halt, {:error, msg}}

        {:ok, new_data} ->
          {:cont, {:ok, new_data}}
      end
    end)
  end
end
