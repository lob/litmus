defmodule Litmus.Type.String do
  @moduledoc false

  alias Litmus.Required
  alias Litmus.Type

  defstruct [
    :min_length,
    :max_length,
    :length,
    regex: %Type.String.Regex{},
    trim: false,
    required: false
  ]

  @type t :: %__MODULE__{
          min_length: non_neg_integer | nil,
          max_length: non_neg_integer | nil,
          length: non_neg_integer | nil,
          regex: Type.String.Regex.t(),
          trim: boolean,
          required: boolean
        }

  @spec validate_field(t, binary, map) :: {:ok, map} | {:error, binary}
  def validate_field(type, field, data) do
    with {:ok, data} <- Required.validate(type, field, data),
         {:ok, data} <- trim(type, field, data),
         {:ok, data} <- min_length_validate(type, field, data),
         {:ok, data} <- max_length_validate(type, field, data),
         {:ok, data} <- length_validate(type, field, data),
         {:ok, data} <- regex_validate(type, field, data) do
      {:ok, data}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @spec min_length_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp min_length_validate(%__MODULE__{min_length: min_length}, field, params)
       when min_length != nil and is_integer(min_length) and min_length >= 0 do
    if Map.has_key?(params, field) && String.length(params[field]) < min_length do
      {:error, "#{field} length must be greater than or equal to #{min_length} characters"}
    else
      {:ok, params}
    end
  end

  defp min_length_validate(%__MODULE__{min_length: nil}, _field, params) do
    {:ok, params}
  end

  @spec max_length_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp max_length_validate(%__MODULE__{max_length: max_length}, field, params)
       when max_length != nil and is_integer(max_length) and max_length >= 0 do
    if Map.has_key?(params, field) && String.length(params[field]) > max_length do
      {:error, "#{field} length must be less than or equal to #{max_length} characters"}
    else
      {:ok, params}
    end
  end

  defp max_length_validate(%__MODULE__{max_length: nil}, _field, params) do
    {:ok, params}
  end

  @spec length_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp length_validate(%__MODULE__{length: length}, field, params)
       when length != nil and is_integer(length) and length >= 0 do
    if Map.has_key?(params, field) && String.length(params[field]) != length do
      {:error, "#{field} length must be #{length} characters"}
    else
      {:ok, params}
    end
  end

  defp length_validate(%__MODULE__{length: nil}, _field, params) do
    {:ok, params}
  end

  @spec regex_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp regex_validate(%__MODULE__{regex: %{pattern: regex, error_message: msg}}, field, params)
       when regex != nil and msg != nil do
    if Map.has_key?(params, field) and !Regex.match?(regex, params[field]) do
      {:error, msg}
    else
      {:ok, params}
    end
  end

  defp regex_validate(%__MODULE__{regex: %{pattern: regex, error_message: nil}}, field, params)
       when regex != nil do
    if Map.has_key?(params, field) and !Regex.match?(regex, params[field]) do
      {:error, "#{field} must be in a valid format"}
    else
      {:ok, params}
    end
  end

  defp regex_validate(%__MODULE__{regex: %{pattern: nil}}, _field, params) do
    {:ok, params}
  end

  @spec trim(t, binary, map) :: {:ok, map}
  defp trim(%__MODULE__{trim: true}, field, params) do
    if Map.has_key?(params, field) do
      trimmed_params = Map.put(params, field, String.trim(params[field]))
      {:ok, trimmed_params}
    else
      {:ok, params}
    end
  end

  defp trim(%__MODULE__{trim: false}, _field, params) do
    {:ok, params}
  end

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), binary, map) :: {:ok, map} | {:error, binary}
    def validate(type, field, data), do: Type.String.validate_field(type, field, data)
  end
end
