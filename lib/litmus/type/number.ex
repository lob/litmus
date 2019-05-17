defmodule Litmus.Type.Number do
  @moduledoc """
  This type validates that values are numbers, and converts them to numbers if
  possible. It converts "stringified" numerical values to numbers.

  ## Options

    * `:default` - Setting `:default` will populate a field with the provided
      value, assuming that it is not present already. If a field already has a
      value present, it will not be altered.

    * `:min` - Specifies the minimum value of the field.

    * `:max` - Specifies the maximum value of the field.

    * `:integer` - Specifies that the number must be an integer (no floating
      point). Allowed values are `true` and `false`. The default is `false`.

    * `:required` - Setting `:required` to `true` will cause a validation error
      when a field is not present or the value is `nil`. Allowed values for
      required are `true` and `false`. The default is `false`.

  ## Examples

      iex> schema = %{
      ...>   "id" => %Litmus.Type.Number{
      ...>     integer: true
      ...>   },
      ...>   "gpa" => %Litmus.Type.Number{
      ...>     min: 0,
      ...>     max: 4
      ...>   }
      ...> }
      iex> params = %{"id" => "123", "gpa" => 3.8}
      iex> Litmus.validate(params, schema)
      {:ok, %{"id" => 123, "gpa" => 3.8}}
      iex> params = %{"id" => "123.456", "gpa" => 3.8}
      iex> Litmus.validate(params, schema)
      {:error, "id must be an integer"}

      iex> schema = %{
      ...>   "gpa" => %Litmus.Type.Number{
      ...>     default: 4
      ...>   }
      ...> }
      iex> Litmus.validate(%{}, schema)
      {:ok, %{"gpa" => 4}}

  """

  defstruct [
    :min,
    :max,
    default: Litmus.Type.Any.NoDefault,
    integer: false,
    required: false
  ]

  @type t :: %__MODULE__{
          default: any,
          min: number | nil,
          max: number | nil,
          integer: boolean,
          required: boolean
        }

  alias Litmus.{Default, Required}

  @spec validate_field(t, binary, map) :: {:ok, map} | {:error, binary}
  def validate_field(type, field, data) do
    with {:ok, data} <- Required.validate(type, field, data),
         {:ok, data} <- Default.validate(type, field, data),
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

      params[field] == nil ->
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
