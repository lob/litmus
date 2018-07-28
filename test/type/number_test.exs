defmodule Litmus.Type.NumberTest do
  use ExUnit.Case

  alias Litmus.Type

  describe "validate_field/3" do
    test "validates property values of data based on their Number schema definition in Type.Number module" do
      field = "id"
      data = %{"id" => 1}

      type = %Type.Number{
        required: true
      }

      assert Type.Number.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "convert string to number" do
    test "returns :ok with modified value when convert is true" do
      data = %{"id" => ".6"}

      schema = %{
        "id" => %Litmus.Type.Number{}
      }

      modified_data = %{"id" => 0.6}
      assert Litmus.validate(data, schema) == {:ok, modified_data}
    end

    test "errors when convert is true and field type is neither number or string" do
      field = "id"
      data = %{"id" => "1.a"}

      schema = %{
        "id" => %Litmus.Type.Number{}
      }

      assert Litmus.validate(data, schema) == {:error, "#{field} must be a number"}
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
      min = 3
      field = "id"
      data = %{"id" => 1}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          min: min
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error, "#{field} must be greater than or equal to #{min}"}
    end
  end

  describe "maximum validation" do
    test "returns :ok when field is less than or equal to max" do
      max = 3
      data = %{"id" => 1}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          max: max
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when field is more than max" do
      max = 3
      field = "id"
      data = %{"id" => 6}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          max: max
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error, "#{field} must be less than or equal to #{max}"}
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

    test "errors when field is not an integer and the schema property integer is set to true" do
      field = "id"
      data = %{"id" => 1.6}

      schema = %{
        "id" => %Litmus.Type.Number{
          required: true,
          integer: true
        }
      }

      assert Litmus.validate(data, schema) == {:error, "#{field} must be an integer"}
    end
  end
end
