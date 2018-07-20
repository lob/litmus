defmodule Litmus.Validation.Params do
  @moduledoc false

  @doc """
  Module for checking if data consists of parameters that have not been defined in schema
  """

  @spec check_additional_params_error(map, map) :: tuple
  def check_additional_params_error(data, schema) do
    result = Map.keys(data) -- Map.keys(schema)

    if result == [] do
      {:ok, nil}
    else
      additional_params = Enum.join(result, ",")
      {:error, "The data has following additional parameters: " <> additional_params}
    end
  end
end
