defmodule Litmus.Type.Any do
  @moduledoc false

  alias Litmus.Required

  defstruct required: false

  @type t :: %__MODULE__{
          required: boolean
        }

  @spec validate_field(t, binary, map) :: {:ok, map} | {:error, binary}
  def validate_field(type, field, data), do: Required.validate(type, field, data)

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), binary, map) :: {:ok, map} | {:error, binary}
    def validate(type, field, data), do: Type.Any.validate_field(type, field, data)
  end
end
