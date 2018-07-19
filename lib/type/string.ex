defmodule Litmus.Type.String do
  @moduledoc """
  Schema and validation for String data type.
  """

  defstruct [
    :min_length,
    :max_length,
    :length,
    :regex,
    trim: false,
    required: false
  ]

  @type t :: %__MODULE__{
          min_length: non_neg_integer,
          max_length: non_neg_integer,
          length: non_neg_integer,
          regex: term,
          trim: boolean,
          required: boolean
        }
end
