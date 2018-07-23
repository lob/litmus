defmodule Litmus do
  @moduledoc File.read!("#{__DIR__}/../README.md")

  alias Litmus.Type

  @doc """
  Validate data based on a schema.
  """
  @spec validate(map, map) :: {:ok, map} | {:error, String.t()}
  def validate(data, schema) do
    case validate_allowed_params(data, schema) do
      :ok -> validate_schema(data, schema)
      {:error, msg} -> {:error, msg}
    end
  end

  @doc false
  @spec validate_allowed_params(map, map) :: :ok | {:error, String.t()}
  defp validate_allowed_params(data, schema) do
    result = Map.keys(data) -- Map.keys(schema)

    case result do
      [] -> :ok
      [field | _rest] -> {:error, "#{field} is not allowed"}
    end
  end

  @doc false
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
