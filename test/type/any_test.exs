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

    assert Type.Any.validate_field(type, field, data) == {:ok, data}
  end
end
