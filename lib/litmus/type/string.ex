defmodule Litmus.Type.String do
  @moduledoc """
  This type validates and converts values to strings It converts boolean and
  number values to strings.

  ## Options

    * `:default` - Setting `:default` will populate a field with the provided
      value, assuming that it is not present already. If a field already has a
      value present, it will not be altered.

    * `:min_length` - Specifies the minimum number of characters allowed in the
      string. Allowed values are non-negative integers.

    * `:max_length` - Specifies the maximum number of characters allowed in the
      string. Allowed values are non-negative integers.

    * `:length` - Specifies the exact number of characters allowed in the
      string. Allowed values are non-negative integers.

    * `:regex` - Specifies a Regular expression that a string must match. Use
      the `Litmus.Type.String.Regex` struct with the options:

      * `:pattern` - The regex to match
      * `:error_message` - An error message to use when the pattern does not match

    * `:required` - Setting `:required` to `true` will cause a validation error
      when a field is not present or the value is `nil`. Allowed values for
      required are `true` and `false`. The default is `false`.

    * `:trim` - Removes additional whitespace at the front and end of a string.
      Allowed values are `true` and `false`. The default is `false`.

  ## Examples

      iex> schema = %{
      ...>   "username" => %Litmus.Type.String{
      ...>     min_length: 3,
      ...>     max_length: 10,
      ...>     trim: true
      ...>   },
      ...>   "password" => %Litmus.Type.String{
      ...>     length: 6,
      ...>     regex: %Litmus.Type.String.Regex{
      ...>       pattern: ~r/^[a-zA-Z0-9_]*$/,
      ...>       error_message: "password must be alphanumeric"
      ...>     }
      ...>   }
      ...> }
      iex> params = %{"username" => " user123 ", "password" => "root01"}
      iex> Litmus.validate(params, schema)
      {:ok, %{"username" => "user123", "password" => "root01"}}
      iex> Litmus.validate(%{"password" => "ro!_@1"}, schema)
      {:error, "password must be alphanumeric"}

      iex> schema = %{
      ...>   "username" => %Litmus.Type.String{
      ...>     default: "anonymous"
      ...>   }
      ...> }
      iex> Litmus.validate(%{}, schema)
      {:ok, %{"username" => "anonymous"}}

  """

  alias Litmus.{Default, Required}
  alias Litmus.Type

  defstruct [
    :min_length,
    :max_length,
    :length,
    default: Litmus.Type.Any.NoDefault,
    regex: %Type.String.Regex{},
    trim: false,
    required: false
  ]

  @type t :: %__MODULE__{
          default: any,
          min_length: non_neg_integer | nil,
          max_length: non_neg_integer | nil,
          length: non_neg_integer | nil,
          regex: Type.String.Regex.t(),
          trim: boolean,
          required: boolean
        }

  @spec validate_field(t, String.t(), map) :: {:ok, map} | {:error, String.t()}
  def validate_field(type, field, data) do
    with {:ok, data} <- Required.validate(type, field, data),
         {:ok, data} <- Default.validate(type, field, data),
         {:ok, data} <- convert(type, field, data),
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

  @spec convert(t, String.t(), map) :: {:ok, map} | {:error, String.t()}
  defp convert(%__MODULE__{}, field, params) do
    cond do
      !Map.has_key?(params, field) ->
        {:ok, params}

      params[field] == nil ->
        {:ok, params}

      is_binary(params[field]) ->
        {:ok, params}

      is_number(params[field]) or is_boolean(params[field]) ->
        {:ok, Map.update!(params, field, &to_string/1)}

      true ->
        {:error, "#{field} must be a string"}
    end
  end

  @spec min_length_validate(t, String.t(), map) :: {:ok, map} | {:error, String.t()}
  defp min_length_validate(%__MODULE__{min_length: min_length}, field, params)
       when is_integer(min_length) and min_length > 0 do
    if Map.has_key?(params, field) &&
         (params[field] == nil or String.length(params[field]) < min_length) do
      {:error, "#{field} length must be greater than or equal to #{min_length} characters"}
    else
      {:ok, params}
    end
  end

  defp min_length_validate(%__MODULE__{}, _field, params) do
    {:ok, params}
  end

  @spec max_length_validate(t, String.t(), map) :: {:ok, map} | {:error, String.t()}
  defp max_length_validate(%__MODULE__{max_length: nil}, _field, params) do
    {:ok, params}
  end

  defp max_length_validate(%__MODULE__{max_length: max_length}, field, params)
       when is_integer(max_length) and max_length >= 0 do
    if Map.get(params, field) && String.length(params[field]) > max_length do
      {:error, "#{field} length must be less than or equal to #{max_length} characters"}
    else
      {:ok, params}
    end
  end

  @spec length_validate(t, String.t(), map) :: {:ok, map} | {:error, String.t()}
  defp length_validate(%__MODULE__{length: nil}, _field, params) do
    {:ok, params}
  end

  defp length_validate(%__MODULE__{length: 0}, field, params) do
    if params[field] in [nil, ""] do
      {:ok, params}
    else
      {:error, "#{field} length must be 0 characters"}
    end
  end

  defp length_validate(%__MODULE__{length: len}, field, params) when is_integer(len) do
    if Map.has_key?(params, field) &&
         (params[field] == nil || String.length(params[field]) != len) do
      {:error, "#{field} length must be #{len} characters"}
    else
      {:ok, params}
    end
  end

  @spec regex_validate(t, String.t(), map) :: {:ok, map} | {:error, String.t()}
  defp regex_validate(%__MODULE__{regex: %{pattern: nil}}, _field, params) do
    {:ok, params}
  end

  defp regex_validate(%__MODULE__{regex: regex}, field, params) do
    if Map.has_key?(params, field) and
         (params[field] == nil or !Regex.match?(regex.pattern, params[field])) do
      error_message = regex.error_message || "#{field} must be in a valid format"
      {:error, error_message}
    else
      {:ok, params}
    end
  end

  @spec trim(t, String.t(), map) :: {:ok, map}
  defp trim(%__MODULE__{trim: true}, field, params) do
    if Map.get(params, field) do
      trimmed_value = String.trim(params[field])
      trimmed_params = Map.put(params, field, trimmed_value)
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

    @spec validate(Type.t(), String.t(), map) :: {:ok, map} | {:error, String.t()}
    def validate(type, field, data), do: Type.String.validate_field(type, field, data)
  end
end
