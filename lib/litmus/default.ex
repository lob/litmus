defmodule Litmus.Default do
  @moduledoc false

  @spec validate(map, String.t(), map) :: {:ok, map}
  def validate(%{default: %{value: default_value}}, field, params) do
    {:ok, Map.put_new(params, field, default_value)}
  end

  def validate(_, _, params), do: {:ok, params}
end
