defmodule Litmus.Type.Boolean do
  @moduledoc """
  This type validates and converts values to booleans. It converts truthy and
  falsy values to `true` or `false`.

  ## Options

    * `:default` - Setting `:default` will populate a field with the provided
      value, assuming that it is not present already. If a field already has a
      value present, it will not be altered.

    * `:required` - Setting `:required` to `true` will cause a validation error
      when a field is not present or the value is `nil`. Allowed values for
      required are `true` and `false`. The default is `false`.

    * `:truthy` - Allows additional values, i.e. truthy values to be considered
      valid booleans by converting them to `true` during validation. Allowed value
      is an array of strings, numbers, or booleans. The default is `[true, "true"]`

    * `:falsy` - Allows additional values, i.e. falsy values to be considered
      valid booleans by converting them to `false` during validation. Allowed value
      is an array of strings, number or boolean values. The default is `[false,
      "false"]`

  ## Examples

      iex> schema = %{
      ...>   "new_user" => %Litmus.Type.Boolean{
      ...>     truthy: ["1"],
      ...>     falsy: ["0"]
      ...>   }
      ...> }
      iex> params = %{"new_user" => "1"}
      iex> Litmus.validate(params, schema)
      {:ok, %{"new_user" => true}}

      iex> schema = %{
      ...>   "new_user" => %Litmus.Type.Boolean{
      ...>     default: false
      ...>   }
      ...> }
      iex> Litmus.validate(%{}, schema)
      {:ok, %{"new_user" => false}}

      iex> schema = %{"new_user" => %Litmus.Type.Boolean{}}
      iex> params = %{"new_user" => 0}
      iex> Litmus.validate(params, schema)
      {:error, "new_user must be a boolean"}

  """

  alias Litmus.{Default, Required}

  @truthy_default [true, "true"]
  @falsy_default [false, "false"]

  defstruct default: Litmus.Type.Any.NoDefault,
            truthy: @truthy_default,
            falsy: @falsy_default,
            required: false

  @type t :: %__MODULE__{
          default: any,
          truthy: [term],
          falsy: [term],
          required: boolean
        }

  @spec validate_field(t, String.t(), map) :: {:ok, map} | {:error, String.t()}
  def validate_field(type, field, data) do
    with {:ok, data} <- Required.validate(type, field, data),
         {:ok, data} <- Default.validate(type, field, data),
         {:ok, data} <- truthy_falsy_validate(type, field, data) do
      {:ok, data}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @spec check_boolean_values(term, [term], [term]) :: boolean
  defp check_boolean_values(initial_value, additional_values, default_values)
       when is_binary(initial_value) do
    allowed_values =
      additional_values
      |> (&(&1 ++ default_values)).()
      |> Enum.uniq()
      |> Enum.map(fn item ->
        if is_binary(item) do
          String.downcase(item)
        end
      end)

    String.downcase(initial_value) in allowed_values
  end

  defp check_boolean_values(initial_value, additional_values, default_values) do
    initial_value in Enum.uniq(additional_values ++ default_values)
  end

  @spec truthy_falsy_validate(t, String.t(), map) :: {:ok, map} | {:error, String.t()}
  defp truthy_falsy_validate(%__MODULE__{falsy: falsy, truthy: truthy}, field, params) do
    cond do
      !Map.has_key?(params, field) ->
        {:ok, params}

      params[field] == nil ->
        {:ok, params}

      check_boolean_values(params[field], truthy, @truthy_default) ->
        {:ok, Map.replace!(params, field, true)}

      check_boolean_values(params[field], falsy, @falsy_default) ->
        {:ok, Map.replace!(params, field, false)}

      true ->
        {:error, "#{field} must be a boolean"}
    end
  end

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), String.t(), map) :: {:ok, map} | {:error, String.t()}
    def validate(type, field, data), do: Type.Boolean.validate_field(type, field, data)
  end
end
