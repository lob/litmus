defmodule Litmus.Type.AnyTest do
  use ExUnit.Case, async: true
  doctest Litmus.Type.Any

  alias Litmus.Type

  describe "validate_field/3" do
    test "validates property values of data based on their Any schema definition in Type.Any module" do
      field = "id"
      data = %{"id" => "1"}

      type = %Type.Any{
        required: true
      }

      assert Type.Any.validate_field(type, field, data) == {:ok, data}
    end
  end
end
