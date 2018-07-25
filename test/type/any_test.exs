defmodule Litmus.Type.AnyTest do
  use ExUnit.Case

  alias Litmus.Type

  describe "Type.validate/3" do
    test "validates data through Type module" do
      field = "id"
      data = %{"id" => "1"}

      type = %Type.Any{
        required: true
      }

      assert Type.validate(type, field, data) == {:ok, data}
    end
  end

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
