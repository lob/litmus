defmodule Litmus.Type.Number do
  @moduledoc false

  defstruct [
    :min,
    :max,
    integer: false,
    required: false
  ]

  @type t :: %__MODULE__{
          min: number | nil,
          max: number | nil,
          integer: boolean,
          required: boolean
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

  @spec convert(t, binary, map) :: {:ok, map} | {:error, binary}
  defp convert(%__MODULE__{}, field, params) do
    cond do
      !Map.has_key?(params, field) ->
        {:ok, params}

      is_number(params[field]) ->
        {:ok, params}

      is_binary(params[field]) && string_to_number(params[field]) ->
        modified_value = string_to_number(params[field])
        {:ok, Map.put(params, field, modified_value)}

      true ->
        {:error, "#{field} must be a number"}
    end
  end

  @spec string_to_number(binary) :: number | nil
  defp string_to_number(str) do
    str = if String.starts_with?(str, "."), do: "0" <> str, else: str

    cond do
      int = string_to_integer(str) -> int
      float = string_to_float(str) -> float
      true -> nil
    end
  end

  @spec string_to_integer(binary) :: number | nil
  defp string_to_integer(str) do
    case Integer.parse(str) do
      {num, ""} -> num
      _ -> nil
    end
  end

  @spec string_to_float(binary) :: number | nil
  defp string_to_float(str) do
    case Float.parse(str) do
      {num, ""} -> num
      _ -> nil
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
       when is_number(min) do
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
       when is_number(max) do
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
