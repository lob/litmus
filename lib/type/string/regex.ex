defmodule Litmus.Type.String.Regex do
  @moduledoc false

  defstruct [:pattern, :error_message]

  @type t :: %__MODULE__{
          pattern: Regex.t() | nil,
          error_message: String.t() | nil
        }
end
