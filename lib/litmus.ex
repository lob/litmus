defmodule Litmus do
  @moduledoc """
  Litmus is a data validation library for Elixir.
  """

  alias Litmus.Type

  @doc """
  Validates and converts data based on a schema.

  ## Examples

      iex> Litmus.validate(%{"id" => "123"}, %{"id" => %Litmus.Type.Number{}})
      {:ok, %{"id" => 123}}

      iex> Litmus.validate(%{"id" => "asdf"}, %{"id" => %Litmus.Type.Number{}})
      {:error, "id must be a number"}

  """
  @spec validate(map, map) :: {:ok, map} | {:error, String.t()}
  def validate(data, schema) do
    case validate_allowed_params(data, schema) do
      :ok -> validate_schema(data, schema)
      {:error, msg} -> {:error, msg}
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
  defp validate_schema(data, schema) do
    Enum.reduce_while(schema, {:ok, data}, fn {field, type}, {:ok, modified_data} ->
      case Type.validate(type, field, modified_data) do
        {:error, msg} ->
          {:halt, {:error, msg}}

        {:ok, new_data} ->
          {:cont, {:ok, new_data}}
      end
    end)
  end
end
