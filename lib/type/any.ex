defmodule Litmus.Type.Any do
  @moduledoc """
  Schema and validation for Any data type.
  """

  defstruct required: false

  @type t :: %__MODULE__{
          required: boolean
        }
end

defimpl Litmus.Type, for: Litmus.Type.Any do
  alias Litmus.Type

  @spec validate(Type.t(), String.t(), map) :: {:ok, map} | {:error, String.t()}
  def validate(_type, _field, data) do
    {:ok, data}
  end
end
