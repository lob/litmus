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
         {:ok, data} <- truthy_validate(type, field, data),
         {:ok, data} <- falsy_validate(type, field, data) do
      {:ok, data}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @spec truthy_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp truthy_validate(%__MODULE__{truthy: truthy}, field, params) do
    if Map.has_key?(params, field) && !(params[field] in Enum.uniq(truthy ++ @truthy_default)) do
      {:error, "#{field} must be boolean value"}
    else
      modified_params = Map.replace!(params, field, true)
      {:ok, modified_params}
    end
  end

  @spec falsy_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  defp falsy_validate(%__MODULE__{falsy: falsy}, field, params) do
    if Map.has_key?(params, field) && !(params[field] in Enum.uniq(falsy ++ @falsy_default)) do
      {:error, "#{field} must be boolean value"}
    else
      modified_params = Map.replace!(params, field, false)
      {:ok, modified_params}
    end
  end

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), binary, map) :: {:ok, map} | {:error, binary}
    def validate(type, field, data), do: Type.Boolean.validate_field(type, field, data)
  end
end
