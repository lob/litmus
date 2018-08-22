defmodule Litmus.TypeTest do
  use ExUnit.Case, async: true

  alias Litmus.Type

  describe "Type.validate/3" do
    test "validates data through Type module for Any type" do
      field = "id"
      data = %{"id" => "1"}

      type = %Type.Any{
        required: true
      }

      assert Type.validate(type, field, data) == {:ok, data}
    end

    test "validates data through Type module for String type" do
      field = "id"
      data = %{"id" => "1"}

      type = %Type.String{
        required: true
      }

      assert Type.validate(type, field, data) == {:ok, data}
    end
  end
end
