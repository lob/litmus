defmodule Litmus.Type.Number do
  @moduledoc """
  Schema and validation for Number data type.
  """

  defstruct [
    :min,
    :max,
    integer: false,
    required: false
  ]

  @type t :: %__MODULE__{
          min: non_neg_integer,
          max: non_neg_integer,
          integer: boolean,
          required: boolean
        }
end
