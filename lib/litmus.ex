defmodule Litmus do
  @moduledoc """
  Documentation for Litmus. Validate data against schema defined.
  """

  alias Litmus.Validation.{Params, Schema}

  @doc """
  Validate your data against a schema

  ## Examples

      iex(1)> alias Litmus.Type
      Litmus.Type
      iex(2)> login_schema = %{"id": %Type.Any{"required": true}, "username": %Type.String{"max_length": 20}}
      %{
        id: %Litmus.Type.Any{required: true},
        username: %Litmus.Type.String{
          length: nil,
          max_length: 20,
          min_length: nil,
          regex: nil,
          required: false,
          trim: false
        }
      }
      iex(3)> req_params = %{"id": 1, "username": "jane doe"}
      %{id: 1, username: "jane doe"}
      iex(4)> Litmus.validate(req_params, login_schema)
      {:ok, %{id: 1, username: "jane doe"}}

  """

  @spec validate(map, map) :: tuple
  def validate(data, schema) do
    case Params.validate_allowed_params(data, schema) do
      {:ok, nil} -> Schema.check_schema_error(data, schema)
      error = {:error, _} -> error
    end
  end
end
