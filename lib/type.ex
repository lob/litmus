defprotocol Litmus.Type do
  @moduledoc false

  alias Litmus.Type.{Any, Boolean, Number, String}

  @type t :: %Any{} | %Boolean{} | %Number{} | %String{}

  @doc "validates the data based on the type"
  @spec validate(t(), String.t(), map) :: {:ok, map} | {:error, String.t()}
  def validate(type, field, data)
end
