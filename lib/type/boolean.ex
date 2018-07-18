defmodule Litmus.Type.Boolean do
  @moduledoc """
  Schema and validation for Boolean data type.
  """

  defstruct [
    truthy: [true, "true"],
    falsy: [false, "false"],
    required: false
  ]

  @type t :: %__MODULE__{
    truthy: [term],
    falsy: [term],
    required: boolean
  }
end
