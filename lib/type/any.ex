defmodule Litmus.Type.Any do
  @moduledoc false

  defstruct required: false

  @type t :: %__MODULE__{
          required: boolean
        }

  @spec add_required_errors(map, binary, t) :: {:ok, map} | {:error, String.t()}
  def add_required_errors(params, field, %Litmus.Type.Any{required: true}) do
    if Map.has_key?(params, field) do
      {:ok, params}
    else
      {:error, "#{field} is required"}
    end
  end

  def add_required_errors(params, _field, %Litmus.Type.Any{required: false}), do: {:ok, params}

  def add_required_errors(_params, _field, %Litmus.Type.Any{required: _}) do
    {:error, "Any.required must be a boolean"}
  end

  @spec validate_keys(map, binary, t) :: {:ok, map} | {:error, String.t()}
  def validate_keys(data, field, type), do: add_required_errors(data, field, type)

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), String.t(), map) :: {:ok, map} | {:error, String.t()}
    def validate(type, field, data), do: Type.Any.validate_keys(data, field, type)
  end
end
