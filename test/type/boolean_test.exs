defmodule Litmus.Type.BooleanTest do
  use ExUnit.Case

  alias Litmus.Type

  describe "validate_field/3" do
    test "validates property values of data based on their Boolean schema definition in Type.Boolean module" do
      field = "id_given"
      data = %{"id_given" => true}

      type = %Type.Boolean{
        required: true
      }

      assert Type.Boolean.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "truthy validation" do
    test "returns :ok with value converted to true when field is in additional truthy values that are considered to be valid booleans" do
      data = %{"id_given" => 1}
      modified_data = %{"id_given" => true}

      schema = %{
        "id_given" => %Litmus.Type.Boolean{
          truthy: [1]
        },
        "new_user" => %Litmus.Type.Boolean{}
      }

      assert Litmus.validate(data, schema) == {:ok, modified_data}
    end

    test "errors when field is not in additional truthy values that are considered to be valid booleans" do
      field = "id_given"
      data = %{"id_given" => "1"}

      schema = %{
        "id_given" => %Litmus.Type.Boolean{
          truthy: [1]
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error,
                "#{field} must be a boolean"}
    end
  end

  describe "falsy validation" do
    test "returns :ok with value converted to true when field is in additional falsy values that are considered to be valid booleans" do
      data = %{"id_given" => 0}
      modified_data = %{"id_given" => false}

      schema = %{
        "id_given" => %Litmus.Type.Boolean{
          falsy: [0]
        }
      }

      assert Litmus.validate(data, schema) == {:ok, modified_data}
    end

    test "errors when field is not in additional falsy values that are considered to be valid booleans" do
      field = "id_given"
      data = %{"id_given" => "0"}

      schema = %{
        "id_given" => %Litmus.Type.Boolean{
          falsy: [0]
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error,
                "#{field} must be a boolean"}
    end
  end
end
