defmodule Litmus.RequiredTest do
  use ExUnit.Case

  alias Litmus.Required
  alias Litmus.Type

  describe "validate/3" do
    test "returns ok when field is required and is present in params" do
      params = %{"id" => "1"}

      type = %Type.Any{
        required: true
      }

      assert Required.validate(type, "id", params) == {:ok, params}
    end

    test "returns error when field is required and not present in params" do
      field = "id"
      params = %{}

      type = %Type.Any{
        required: true
      }

      assert Required.validate(type, field, params) == {:error, "#{field} is required"}
    end

    test "returns ok when field is not required and is not present in params" do
      field = "id"
      params = %{}

      type = %Type.Any{
        required: false
      }

      assert Required.validate(type, field, params) == {:ok, params}
    end
  end
end
