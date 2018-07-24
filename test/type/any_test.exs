defmodule Litmus.Type.AnyTest do
  use ExUnit.Case

  alias Litmus.Type

  test "validates data through Type module" do
    type = %Type.Any{
      required: true
    }

    field = :id

    data = %{
      id: "1"
    }

    assert Type.validate(type, field, data) == {:ok, data}
  end

  test "validates properties of Any schema in Type.Any module" do
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
