defmodule Litmus.Type.BooleanTest do
  use ExUnit.Case

  alias Litmus.Type

  describe "validate_field/3" do
    test "validates property values of data based on their Boolean schema definition in Type.Boolean module" do
      field = "id"
      data = %{"id" => true}

      type = %Type.Boolean{
        required: true
      }

      assert Type.Boolean.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "truthy validation" do
    test "returns :ok with value converted to true when field is in additional truthy values that are considered to be valid booleans" do
      data = %{"id" => 1}
      modified_data = %{"id" => true}

      schema = %{
        "id" => %Litmus.Type.Boolean{
          truthy: [1]
        }
      }

      assert Litmus.validate(data, schema) == {:ok, modified_data}
    end

    test "errors when field is not in additional truthy values that are considered to be valid booleans" do
      field = "id"
      data = %{"id" => "1"}

      schema = %{
        "id" => %Litmus.Type.Boolean{
          truthy: [1]
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error,
                "#{field} must be a boolean"}
    end
  end

end
