defmodule Litmus.Type.BooleanTest do
  use ExUnit.Case, async: true
  doctest Litmus.Type.Boolean

  alias Litmus.Type

  describe "validate_field/3" do
    test "validates Type.Boolean fields in a schema" do
      field = "id_given"
      data = %{"id_given" => true}

      type = %Type.Boolean{
        required: true
      }

      assert Type.Boolean.validate_field(type, field, data) == {:ok, data}
    end

    test "does not convert nil to a boolean" do
      field = "id_given"
      data = %{"id_given" => nil}

      type = %Type.Boolean{}

      assert Type.Boolean.validate_field(type, field, data) == {:ok, data}
    end

    test "does not error if the field is not provided and not required" do
      field = "id"
      data = %{}

      type = %Type.Boolean{
        truthy: [1, "One"]
      }

      assert Type.Boolean.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "truthy validation" do
    test "returns :ok with value converted to true when field is in additional truthy values that are considered to be valid booleans" do
      data = %{"id_given" => 1}
      case_data = %{"id_given" => "onE"}
      modified_data = %{"id_given" => true}

      schema = %{
        "id_given" => %Litmus.Type.Boolean{
          truthy: [1, "One"]
        },
        "new_user" => %Litmus.Type.Boolean{}
      }

      assert Litmus.validate(data, schema) == {:ok, modified_data}
      assert Litmus.validate(case_data, schema) == {:ok, modified_data}
    end

    test "errors when field is not in additional truthy values that are considered to be valid booleans" do
      field = "id_given"
      data = %{"id_given" => "1"}

      schema = %{
        "id_given" => %Litmus.Type.Boolean{
          truthy: [1]
        }
      }

      assert Litmus.validate(data, schema) == {:error, "#{field} must be a boolean"}
    end
  end

  describe "falsy validation" do
    test "returns :ok with value converted to false when field is in additional falsy values that are considered to be valid booleans" do
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

      assert Litmus.validate(data, schema) == {:error, "#{field} must be a boolean"}
    end
  end
end
