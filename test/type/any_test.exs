defmodule Litmus.Type.AnyTest do
  use ExUnit.Case

  alias Litmus.Type

  test "tests protocol implementation for Any data type" do
    type = %Type.Any{
      required: true
    }

    field = :id

    data = %{
      id: "1"
    }

    assert Type.validate(type, field, data) == {:ok, data}
  end

  test "tests validate_keys function for Any data type" do
    type = %Type.Any{
      required: true
    }

    field = :id

    data = %{
      id: "1"
    }

    assert Type.Any.validate_keys(data, field, type) == {:ok, data}
  end

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
             {:error, "Any.required must be a boolean"}
  end
end
