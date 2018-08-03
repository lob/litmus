defmodule Litmus.Type.ListTest do
  use ExUnit.Case

  alias Litmus.Type

  describe "validate_field/3" do
    test "validates property values of data based on their List schema definition in Type.List module" do
      field = "id"
      data = %{"id" => ["1"]}

      type = %Type.List{
        required: true
      }

      assert Type.List.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "check if field is list" do
    test "returns :ok with params if field is a list" do
      data = %{"id" => [1, 2, 3]}

      schema = %{
        "id" => %Litmus.Type.List{
          required: true
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors if field is not a list" do
      data = %{"id" => "1, 2, 3"}

      schema = %{
        "id" => %Litmus.Type.List{
          required: true
        }
      }

      assert Litmus.validate(data, schema) == {:error, "id must be a list"}
    end
  end

  describe "minimum length validation" do
    test "returns :ok when field list length is more than or equal to min_length" do
      min_length = 3
      data = %{"id" => [1, 2, 3]}

      schema = %{
        "id" => %Litmus.Type.List{
          required: true,
          min_length: min_length
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when field list length is less than min_length" do
      data = %{"id" => [1, 2]}

      schema = %{
        "id" => %Litmus.Type.List{
          required: true,
          min_length: 3
        }
      }

      assert Litmus.validate(data, schema) == {:error, "id must not be below length of 3"}
    end
  end

  describe "maximum length validation" do
    test "returns :ok when field list length is less than or equal to max_length" do
      data = %{"id" => [1, 2, 3]}

      schema = %{
        "id" => %Litmus.Type.List{
          required: true,
          max_length: 3
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when field list length is more than max_length" do
      data = %{"id" => [1, 2, 3, 4]}

      schema = %{
        "id" => %Litmus.Type.List{
          required: true,
          max_length: 3
        }
      }

      assert Litmus.validate(data, schema) == {:error, "id must not exceed length of 3"}
    end
  end

  describe "exact length validation" do
    test "returns :ok when field list length is equal to length" do
      data = %{"id" => [1, 2, 3]}

      schema = %{
        "id" => %Litmus.Type.List{
          required: true,
          length: 3
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when field list length is not equal to length" do
      data = %{"id" => [1, 2]}

      schema = %{
        "id" => %Litmus.Type.List{
          required: true,
          length: 3
        }
      }

      assert Litmus.validate(data, schema) == {:error, "id length must be of 3 length"}
    end
  end

  describe "list element type validation" do
    test "returns :ok with params if field elements are of any type if no type specified" do
      data = %{"id" => [1, "2", 3]}

      schema = %{
        "id" => %Litmus.Type.List{
          required: true
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :ok with params if field elements are of the type specified" do
      data = %{
        "id_atom" => [:a, :b],
        "id_boolean" => [true, false],
        "id_number" => [1, 2],
        "id_string" => ["a", "b"]
      }

      schema = %{
        "id_atom" => %Litmus.Type.List{
          required: true,
          type: "atom"
        },
        "id_boolean" => %Litmus.Type.List{
          required: true,
          type: "boolean"
        },
        "id_number" => %Litmus.Type.List{
          required: true,
          type: "number"
        },
        "id_string" => %Litmus.Type.List{
          required: true,
          type: "string"
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors if field elements are not of the type specified" do
      data = %{"id" => [1, 2, "3", :a, true]}

      schema_atom = %{"id" => %Litmus.Type.List{type: "atom"}}
      schema_boolean = %{"id" => %Litmus.Type.List{type: "boolean"}}
      schema_number = %{"id" => %Litmus.Type.List{type: "number"}}
      schema_string = %{"id" => %Litmus.Type.List{type: "string"}}

      assert Litmus.validate(data, schema_atom) == {:error, "id must be a list of atoms"}
      assert Litmus.validate(data, schema_boolean) == {:error, "id must be a list of boolean"}
      assert Litmus.validate(data, schema_number) == {:error, "id must be a list of numbers"}
      assert Litmus.validate(data, schema_string) == {:error, "id must be a list of strings"}
    end
  end
end
