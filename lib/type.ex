defprotocol Litmus.Type do
  @moduledoc false

  alias Litmus.Type

  @type t :: Type.Any.t() | Type.Boolean.t() | Type.Number.t() | Type.String.t()

  @spec validate(t(), binary, map) :: {:ok, map} | {:error, binary}
  def validate(type, field, data)
end
