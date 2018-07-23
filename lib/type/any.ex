defmodule Litmus.Type.Any do
  @moduledoc """
  Schema and validation for Any data type.
  """

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

  def add_required_errors(_params, field, %Litmus.Type.Any{required: _}) do
    {:error, "Incorrect schema defined for #{field}"}
  end
end

defimpl Litmus.Type, for: Litmus.Type.Any do
  alias Litmus.Type

  @spec validate(Type.t(), String.t(), map) :: {:ok, map} | {:error, String.t()}
  def validate(type, field, data) do
    case Type.Any.add_required_errors(data, field, type) do
      {:ok, data} -> {:ok, data}
      {:error, msg} -> {:error, msg}
    end
  end
end
