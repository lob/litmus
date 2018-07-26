defmodule Litmus.Type.StringTest do
  use ExUnit.Case

  alias Litmus.Type

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

  describe "minimum length validation" do
    test "returns :ok when length of field is more than or equal to min_length" do
      min_length = 3
      data = %{"id" => "abc"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          min_length: min_length
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when length of field is less than min_length" do
      min_length = 3
      field = "id"
      data = %{"id" => "ab"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          min_length: min_length
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error,
                "#{field} length must be greater than or equal to #{min_length} characters"}
    end
  end

  describe "maximum length validation" do
    test "returns :ok when length of field is less than or equal to max_length" do
      max_length = 3
      data = %{"id" => "ab"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          max_length: max_length
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when length of field is more than max_length" do
      max_length = 3
      field = "id"
      data = %{"id" => "abcd"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          max_length: max_length
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error, "#{field} length must be less than or equal to #{max_length} characters"}
    end
  end

  describe "exact length validation" do
    test "returns :ok when length of field is equal to length" do
      length = 3
      data = %{"id" => "abc"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          length: length
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when length of field is not equal to length" do
      length = 3
      field = "id"
      data = %{"id" => "abcd"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          length: length
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error, "#{field} length must be #{length} characters"}
    end
  end

  describe "regex validation" do
    test "returns :ok when value matches the regex pattern" do
      data = %{"zip_code" => "94107-1741"}

      schema = %{
        "zip_code" => %Litmus.Type.String{
          min_length: 5,
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^\d{3,}(?:[-\s]?\d*)?$/,
            error_message: "zip_code must be in a valid zip or zip+4 format"
          },
          trim: true
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors with custom error message when value does not match regex pattern" do
      data = %{"zip_code" => "94107-xxxx"}

      schema = %{
        "zip_code" => %Litmus.Type.String{
          min_length: 5,
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^\d{3,}(?:[-\s]?\d*)?$/,
            error_message: "zip_code must be in a valid zip or zip+4 format"
          },
          trim: true
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error, "zip_code must be in a valid zip or zip+4 format"}
    end

    test "errors with default error message when value does not match regex pattern" do
      data = %{"zip_code" => "94107-xxxx"}
      field = "zip_code"

      schema = %{
        "zip_code" => %Litmus.Type.String{
          min_length: 5,
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^\d{3,}(?:[-\s]?\d*)?$/
          },
          trim: true
        }
      }

      assert Litmus.validate(data, schema) == {:error, "#{field} must be in a valid format"}
    end
  end

  describe "trim extra whitespaces" do
    test "returns :ok with new parameters having trimmed values when trim is set to true" do
      data = %{"id" => "abc "}
      trimmed_data = %{"id" => "abc"}

      schema = %{
        "id" => %Litmus.Type.String{
          max_length: 3,
          required: true,
          trim: true
        }
      }

      assert Litmus.validate(data, schema) == {:ok, trimmed_data}
    end

    test "returns :ok with same parameters when trim is set to false" do
      data = %{"id" => "abc"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          trim: false
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end
  end
end
