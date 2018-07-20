defprotocol Litmus.Type do
  @moduledoc false

  alias Litmus.Type

  @type t :: %Type.Any{} | %Type.Boolean{} | %Type.Number{} | %Type.String{}

  @doc "validates the data based on the type"
  @spec validate(t(), String.t(), map) :: {:ok, map} | {:error, String.t()}
  def validate(type, field, data)
end
