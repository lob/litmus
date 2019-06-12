defmodule Litmus.Type.NumberTest do
  use ExUnit.Case, async: true
  doctest Litmus.Type.Number

  alias Litmus.Type

  describe "validate_field/3" do
    test "validates Type.Number fields in a schema" do
      field = "id"
      data = %{"id" => 1}

      type = %Type.Number{
        required: true
      }

      assert Type.Number.validate_field(type, field, data) == {:ok, data}
    end

    test "does not error if the field is not provided and not required" do
      field = "id"
      data = %{}

      type = %Type.Number{
        min: 3
      }

      assert Type.Number.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "convert string to number" do
    test "returns :ok with modified value" do
      float_data = %{"id" => ".6"}
      integer_data = %{"id" => "6"}
      modified_float_data = %{"id" => 0.6}
      modified_integer_data = %{"id" => 6}

      schema = %{
        "id" => %Litmus.Type.Number{}
      }

      assert Litmus.validate(integer_data, schema) == {:ok, modified_integer_data}
      assert Litmus.validate(float_data, schema) == {:ok, modified_float_data}
    end

    test "errors if field type is neither number or stringified number" do
      invalid_number = %{"id" => "1.a"}
      boolean_data = %{"id" => true}

      schema = %{
        "id" => %Litmus.Type.Number{}
      }

      assert Litmus.validate(invalid_number, schema) == {:error, "id must be a number"}
      assert Litmus.validate(boolean_data, schema) == {:error, "id must be a number"}
    end

    test "does not convert nil to a number" do
      field = "id"
      data = %{"id" => nil}

      type = %Type.Number{}

      assert Type.Number.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "minimum validation" do
    test "returns :ok when field is more than or equal to min value" do
      data = %{"id" => 6}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          min: 3
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when field is less than min" do
      data = %{"id" => 1}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          min: 3
        }
      }

      assert Litmus.validate(data, schema) == {:error, "id must be greater than or equal to 3"}
    end
  end

  describe "maximum validation" do
    test "returns :ok when field is less than or equal to max" do
      data = %{"id" => 1}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          max: 3
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when field is more than max" do
      data = %{"id" => 6}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          max: 3
        }
      }

      assert Litmus.validate(data, schema) == {:error, "id must be less than or equal to 3"}
    end
  end

  describe "integer type validation" do
    test "returns :ok when field is an integer and the schema property integer is set to true" do
      data = %{"id" => 1}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          integer: true
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when field is a float and the schema property integer is set to true" do
      data = %{"id" => 1.6}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          integer: true
        }
      }

      assert Litmus.validate(data, schema) == {:error, "id must be an integer"}
    end
  end
end
