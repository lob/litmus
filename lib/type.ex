defprotocol Litmus.Type do
  @moduledoc false

  alias Litmus.Type

  @type t :: Type.Any.t() | Type.Boolean.t() | Type.List.t() | Type.Number.t() | Type.String.t()

  @spec validate(t(), String.t(), map) :: {:ok, map} | {:error, String.t()}
  def validate(type, field, data)
end
