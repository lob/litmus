defmodule Litmus.Default do
  @moduledoc false

  alias Litmus.Type.Any.NoDefault

  @spec validate(map, String.t(), map) :: {:ok, map}
  def validate(%{default: default_value}, field, params) when default_value != NoDefault do
    {:ok, Map.put_new(params, field, default_value)}
  end

  def validate(_, _, params), do: {:ok, params}
end
