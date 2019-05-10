defmodule Litmus.Type.DateTime do
  @moduledoc """
  This type validates DateTimes. It accepts either `DateTime` structs or
  ISO-8601 strings. ISO-8601 datetime with timezone strings will be converted
  into `DateTime`s.

  ## Options

    * `:default` - Setting `:default` will populate a field with the provided
      value, assuming that it is not present already. If a field already has a
      value present, it will not be altered. The default can either be a `DateTime`
      or an ISO-8601 string.

    * `:required` - Setting `:required` to `true` will cause a validation error
      when a field is not present or the value is `nil`. Allowed values for
      required are `true` and `false`. The default is `false`.

  ## Examples

      iex> schema = %{"start_date" => %Litmus.Type.DateTime{}}
      iex> {:ok, %{"start_date" => datetime}} = Litmus.validate(%{"start_date" => "2017-06-18T05:45:33Z"}, schema)
      iex> datetime
      #DateTime<2017-06-18 05:45:33Z>

      iex> schema = %{
      ...>   "start_date" => %Litmus.Type.DateTime{
      ...>     default: "2019-05-01T06:25:00-0700"
      ...>   }
      ...> }
      iex> {:ok, %{"start_date" => datetime}} = Litmus.validate(%{}, schema)
      iex> datetime
      #DateTime<2019-05-01 13:25:00Z>

      iex> {:ok, default_datetime, _} = DateTime.from_iso8601("2019-05-01T06:25:00-0700")
      ...> schema = %{
      ...>   "start_date" => %Litmus.Type.DateTime{
      ...>     default: default_datetime
      ...>   }
      ...> }
      iex> {:ok, %{"start_date" => datetime}} = Litmus.validate(%{}, schema)
      iex> datetime
      #DateTime<2019-05-01 13:25:00Z>

  """

  alias Litmus.{Default, Required}
  alias Litmus.Type

  defstruct default: Litmus.Type.Any.NoDefault,
            required: false

  @type t :: %__MODULE__{
          default: any,
          required: boolean
        }

  @spec validate_field(t, String.t(), map) :: {:ok, map} | {:error, String.t()}
  def validate_field(type, field, data) do
    with {:ok, data} <- Required.validate(type, field, data),
         {:ok, data} <- Default.validate(type, field, data),
         {:ok, data} <- convert(type, field, data) do
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
        case DateTime.from_iso8601(params[field]) do
          {:ok, date_time, _utc_offset} -> {:ok, Map.put(params, field, date_time)}
          {:error, _} -> error_tuple(field)
        end

      datetime?(params[field]) ->
        {:ok, params}

      true ->
        error_tuple(field)
    end
  end

  @spec datetime?(term) :: boolean
  defp datetime?(%DateTime{}), do: true
  defp datetime?(_), do: false

  @spec error_tuple(String.t()) :: {:error, String.t()}
  defp error_tuple(field) do
    {:error, "#{field} must be a valid ISO-8601 datetime"}
  end

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), String.t(), map) :: {:ok, map} | {:error, String.t()}
    def validate(type, field, data), do: Type.DateTime.validate_field(type, field, data)
  end
end
