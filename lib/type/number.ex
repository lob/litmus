defmodule Litmus.Type.Number do
  @moduledoc """
  Schema and validation for Number data type.
  """

  defstruct [
    :min,
    :max,
    integer: false,
    required: false
  ]

  @type t :: %__MODULE__{
          min: non_neg_integer,
          max: non_neg_integer,
          integer: boolean,
          required: boolean
        }

  @spec validate_field(t, binary, map) :: {:ok, map} | {:error, binary}
  def validate_field(type, field, data) do
    with {:ok, data} <- Required.validate(type, field, data),
          {:ok, data} <- min_validate(type, field, data),
          {:ok, data} <- max_validate(type, field, data),
          {:ok, data} <- integer_validate(type, field, data) do
      {:ok, data}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @spec min_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp min_validate(%__MODULE__{min: min}, field, params)
       when min != nil and is_integer(min) and min >= 0 do
    if Map.has_key?(params, field) && String.length(params[field]) < min do
      {:error, "#{field} length must be greater than or equal to #{min} characters"}
    else
      {:ok, params}
    end
  end

  defp min_validate(%__MODULE__{min: nil}, _field, params) do
    {:ok, params}
  end

  @spec max_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp max_validate(%__MODULE__{max: max}, field, params)
       when max != nil and is_integer(max) and max >= 0 do
    if Map.has_key?(params, field) && String.length(params[field]) > max do
      {:error, "#{field} length must be less than or equal to #{max} characters"}
    else
      {:ok, params}
    end
  end

  defp max_validate(%__MODULE__{max: nil}, _field, params) do
    {:ok, params}
  end

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), binary, map) :: {:ok, map} | {:error, binary}
    def validate(type, field, data), do: Type.Number.validate_field(type, field, data)
  end
end
