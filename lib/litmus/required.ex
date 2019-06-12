defmodule Litmus.Required do
  @moduledoc false

  @spec validate(map, String.t(), map) :: {:ok | :ok_not_present, map} | {:error, String.t()}
  def validate(%{required: true}, field, params) do
    if Map.has_key?(params, field) && params[field] != nil do
      {:ok, params}
    else
      {:error, "#{field} is required"}
    end
  end

  def validate(%{required: false}, field, params) do
    if Map.has_key?(params, field) do
      {:ok, params}
    else
      {:ok_not_present, params}
    end
  end
end
