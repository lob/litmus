defmodule Litmus.Type.Any do
  @moduledoc """
  Schema and validation for Any data type.
  """

  defstruct required: false

  @type t :: %__MODULE__{
          required: boolean
        }
end
