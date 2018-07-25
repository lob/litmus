defmodule Litmus.Type.StringTest do
  use ExUnit.Case

  alias Litmus.Type

  test "tests protocol implementation for String data type" do
    type = %Type.String{
      required: true
    }

    field = :id

    data = %{
      id: "1"
    }

    assert Type.validate(type, field, data) == {:ok, data}
  end

  test "tests validate_keys function for String data type" do
    type = %Type.String{
      required: true
    }

    field = :id

    data = %{
      id: "1"
    }

    assert Type.String.validate_field(type, field, data) == {:ok, data}
  end

  test "tests min_length_validate function for String data type" do
    min_length = 3

    type = %Type.String{
      required: true,
      min_length: min_length
    }

    field = :id

    data = %{
      id: "abc"
    }

    assert Type.String.min_length_validate(type, field, data) == {:ok, data}

    data = %{
      id: "ab"
    }

    assert Type.String.min_length_validate(type, field, data) ==
             {:error,
              "#{field} length must be more than or equal to #{min_length} characters long"}
  end

  test "tests max_length_validate function for String data type" do
    max_length = 3

    type = %Type.String{
      required: true,
      max_length: max_length
    }

    field = :id

    data = %{
      id: "ab"
    }

    assert Type.String.max_length_validate(type, field, data) == {:ok, data}

    data = %{
      id: "abcd"
    }

    assert Type.String.max_length_validate(type, field, data) ==
             {:error,
              "#{field} length must be less than or equal to #{max_length} characters long"}
  end

  test "tests length_validate function for String data type" do
    length = 3

    type = %Type.String{
      required: true,
      length: length
    }

    field = :id

    data = %{
      id: "abc"
    }

    assert Type.String.length_validate(type, field, data) == {:ok, data}

    data = %{
      id: "abcd"
    }

    assert Type.String.length_validate(type, field, data) ==
             {:error, "#{field} length must be #{length} characters long"}
  end
end
