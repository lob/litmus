defmodule Litmus.Type.String.Replace do
  @moduledoc false

  defstruct [
    :pattern,
    :replacement,
    global: true
  ]

  @type t :: %__MODULE__{
          pattern: String.pattern() | Regex.t() | nil,
          replacement: String.t() | nil,
          global: boolean
        }
end
