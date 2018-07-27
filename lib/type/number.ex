defmodule Litmus.Type.Number do
  @moduledoc """
  Schema and validation for Number data type.
  """

  defstruct [
    :min,
    :max,
    integer: false,
    required: false,
    convert: true
  ]

  @type t :: %__MODULE__{
          min: non_neg_integer | nil,
          max: non_neg_integer | nil,
          integer: boolean,
          required: boolean,
          convert: boolean
        }

  alias Litmus.Required

  @spec validate_field(t, binary, map) :: {:ok, map} | {:error, binary}
  def validate_field(type, field, data) do
    with {:ok, data} <- Required.validate(type, field, data),
         {:ok, data} <- convert(type, field, data),
         {:ok, data} <- min_validate(type, field, data),
         {:ok, data} <- max_validate(type, field, data),
         {:ok, data} <- integer_validate(type, field, data) do
      {:ok, data}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @spec string_to_number(binary) :: number | :error
  defp string_to_number(str) do
    modified_str =
      try do
        String.to_integer(str)
      rescue
        ArgumentError ->
          try do
            String.to_float("0" <> str)
          rescue
            ArgumentError ->
              :error
          end
      end

    modified_str
  end

  @spec convert(t, binary, map) :: {:ok, map} | {:error, binary}
  defp convert(%__MODULE__{convert: false}, _field, params) do
    {:ok, params}
  end

  defp convert(%__MODULE__{convert: true}, field, params) do
    if Map.has_key?(params, field) && !(is_binary(params[field]) || is_number(params[field])) do
      {:error, "#{field} must be a valid number"}
    else
      if is_binary(params[field]) do
        modified_value = string_to_number(params[field])

        case modified_value do
          :error ->
            {:error, "#{field} must be a valid number"}

          _ ->
            modified_params = Map.put(params, field, modified_value)
            {:ok, modified_params}
        end
      else
        {:ok, params}
      end
    end
  end

  @spec integer_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp integer_validate(%__MODULE__{integer: false}, _field, params) do
    {:ok, params}
  end

  defp integer_validate(%__MODULE__{integer: true}, field, params) do
    if Map.has_key?(params, field) && !is_integer(params[field]) do
      {:error, "#{field} must be an integer"}
    else
      {:ok, params}
    end
  end

  @spec min_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp min_validate(%__MODULE__{min: nil}, _field, params) do
    {:ok, params}
  end

  defp min_validate(%__MODULE__{min: min}, field, params)
       when is_number(min) and min >= 0 do
    if Map.has_key?(params, field) && params[field] < min do
      {:error, "#{field} must be greater than or equal to #{min}"}
    else
      {:ok, params}
    end
  end

  @spec max_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp max_validate(%__MODULE__{max: nil}, _field, params) do
    {:ok, params}
  end

  defp max_validate(%__MODULE__{max: max}, field, params)
       when is_number(max) and max >= 0 do
    if Map.has_key?(params, field) && params[field] > max do
      {:error, "#{field} must be less than or equal to #{max}"}
    else
      {:ok, params}
    end
  end

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), binary, map) :: {:ok, map} | {:error, binary}
    def validate(type, field, data), do: Type.Number.validate_field(type, field, data)
  end
end
