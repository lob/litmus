defmodule Litmus.RequiredTest do
  use ExUnit.Case

  alias Litmus.Required
  alias Litmus.Type

  test "returns ok when field is required and is present in params" do
    type = %Type.Any{
      required: true
    }

    params = %{
      id: "1"
    }

    assert Required.validate(type, :id, params) == {:ok, params}
  end

  test "returns error when field is required and not present in params" do
    field = :id

    type = %Type.Any{
      required: true
    }

    params = %{}

    assert Required.validate(type, field, params) == {:error, "#{field} is required"}
  end

  test "returns ok when field is not required and is not present in params" do
    field = :id

    type = %Type.Any{
      required: false
    }

    params = %{}

    assert Required.validate(type, field, params) == {:ok, params}
  end
end
