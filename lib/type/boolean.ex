defmodule Litmus.Type.Boolean do
  @moduledoc false

  alias Litmus.Required

  @truthy_default [true, "true"]
  @falsy_default [false, "false"]

  defstruct truthy: @truthy_default,
            falsy: @falsy_default,
            required: false

  @type t :: %__MODULE__{
          truthy: [term],
          falsy: [term],
          required: boolean
        }

  @spec validate_field(t, binary, map) :: {:ok, map} | {:error, binary}
  def validate_field(type, field, data) do
    with {:ok, data} <- Required.validate(type, field, data),
         {:ok, data} <- truthy_falsy_validate(type, field, data) do
      {:ok, data}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @spec truthy_falsy_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp truthy_falsy_validate(%__MODULE__{falsy: falsy, truthy: truthy}, field, params) do
    cond do
      !Map.has_key?(params, field) ->
        {:ok, params}

      params[field] in Enum.uniq(truthy ++ @truthy_default) ->
        {:ok, Map.replace!(params, field, true)}

      params[field] in Enum.uniq(falsy ++ @falsy_default) ->
        {:ok, Map.replace!(params, field, false)}

      true ->
        {:error, "#{field} must be a boolean"}
    end
  end

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), binary, map) :: {:ok, map} | {:error, binary}
    def validate(type, field, data), do: Type.Boolean.validate_field(type, field, data)
  end
end
