defmodule Litmus.Validation.Schema do
  @moduledoc false

  @doc """
  Module for checking and routing to individual schema specific validation
  """

  alias Litmus.Type.{Any, Boolean, Number, String}

  @spec check_schema_error(map, map) :: tuple
  def check_schema_error(data, schema) do
    Enum.reduce_while(schema, %{}, fn {k, v}, acc ->
      data
      |> validate_schema(k, v)
      |> case do
        {:error, error_message} ->
          {:halt, {:error, error_message}}

        {:ok, data} ->
          acc = data
          {:cont, {:ok, acc}}
      end
    end)
  end

  def validate_schema(data, _, %Any{}) do
    {:ok, data}
  end

  def validate_schema(data, _, %Boolean{}) do
    {:ok, data}
  end

  def validate_schema(data, _, %Number{}) do
    {:ok, data}
  end

  def validate_schema(data, _, %String{}) do
    {:ok, data}
  end

  def validate_schema(_, _, _) do
    {:error, "Incorrect schema passed"}
  end
end
