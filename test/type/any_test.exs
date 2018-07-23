defmodule Litmus.Type.AnyTest do
  use ExUnit.Case

  alias Litmus.Type

  test "returns ok when field is required and is present in params" do
    field = :id

    type = %Type.Any{
      required: true
    }

    params = %{
      id: "1"
    }

    assert Type.Any.add_required_errors(params, field, type) == {:ok, params}
  end

  test "returns error when field is required and not present in params" do
    field = :id

    type = %Type.Any{
      required: true
    }

    params = %{}

    assert Type.Any.add_required_errors(params, field, type) == {:error, "#{field} is required"}
  end

  test "returns ok when field is not required and is not present in params" do
    field = :id

    type = %Type.Any{
      required: false
    }

    params = %{}

    assert Type.Any.add_required_errors(params, field, type) == {:ok, params}
  end

  test "returns error when the schema defined for field has incorrect value" do
    field = :id

    type = %Type.Any{
      required: "true"
    }

    params = %{
      id: "1"
    }

    assert Type.Any.add_required_errors(params, field, type) ==
             {:error, "Incorrect schema defined for #{field}"}
  end
end
