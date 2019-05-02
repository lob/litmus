defmodule Litmus.Type.Any.Default do
  @moduledoc false

  defstruct [:value]

  @type t :: %__MODULE__{
          value: any | nil
        }
end
