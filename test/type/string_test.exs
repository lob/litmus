defmodule Litmus.Type.StringTest do
  use ExUnit.Case

  alias Litmus.Type

  describe "Type.validate/3" do
    test "validates data through Type module" do
      field = "id"
      data = %{"id" => "1"}

      type = %Type.String{
        required: true
      }

      assert Type.validate(type, field, data) == {:ok, data}
    end
  end

  describe "validate_field/3" do
    test "validates property values of data based on their String schema definition in Type.String module" do
      field = "id"
      data = %{"id" => "1"}

      type = %Type.String{
        required: true
      }

      assert Type.String.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "min_length_validate/3" do
    test "returns :ok when length of field is more than or equal to min_length" do
      min_length = 3
      field = "id"
      data = %{"id" => "abc"}

      type = %Type.String{
        required: true,
        min_length: min_length
      }

      assert Type.String.min_length_validate(type, field, data) == {:ok, data}
    end

    test "errors when length of field is less than min_length" do
      min_length = 3
      field = "id"
      data = %{"id" => "ab"}

      type = %Type.String{
        required: true,
        min_length: min_length
      }

      assert Type.String.min_length_validate(type, field, data) ==
               {:error,
                "#{field} length must be more than or equal to #{min_length} characters long"}
    end
  end

  describe "max_length_validate/3" do
    test "returns :ok when length of field is less than or equal to max_length" do
      max_length = 3
      field = "id"
      data = %{"id" => "ab"}

      type = %Type.String{
        required: true,
        max_length: max_length
      }

      assert Type.String.max_length_validate(type, field, data) == {:ok, data}
    end

    test "errors when length of field is more than max_length" do
      max_length = 3
      field = "id"
      data = %{"id" => "abcd"}

      type = %Type.String{
        required: true,
        max_length: max_length
      }

      assert Type.String.max_length_validate(type, field, data) ==
               {:error,
                "#{field} length must be less than or equal to #{max_length} characters long"}
    end
  end

  describe "length_validate/3" do
    test "returns :ok when length of field is equal to length" do
      length = 3
      field = "id"
      data = %{"id" => "abc"}

      type = %Type.String{
        required: true,
        length: length
      }

      assert Type.String.length_validate(type, field, data) == {:ok, data}
    end

    test "errors when length of field is not equal to length" do
      length = 3
      field = "id"
      data = %{"id" => "abcd"}

      type = %Type.String{
        required: true,
        length: length
      }

      assert Type.String.length_validate(type, field, data) ==
               {:error, "#{field} length must be #{length} characters long"}
    end
  end
end
