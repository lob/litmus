defmodule Litmus.DefaultTest do
  use ExUnit.Case, async: true

  alias Litmus.Default
  alias Litmus.Type

  describe "validate/3" do
    test "returns params with default value populated if field not present" do
      type = %Type.Any{
        default: %Type.Any.Default{value: "12345"}
      }

      assert Default.validate(type, "id", %{}) == {:ok, %{"id" => "12345"}}
    end

    test "returns a default value of nil" do
      type = %Type.Any{
        default: %Type.Any.Default{value: nil}
      }

      assert Default.validate(type, "id", %{}) == {:ok, %{"id" => nil}}
    end

    test "returns unaltered params if field is present" do
      params = %{"id" => "12345"}

      type = %Type.Any{
        default: %Type.Any.Default{value: "67890"}
      }

      assert Default.validate(type, "id", params) == {:ok, params}
    end

    test "does not populate values if default is not present on type" do
      type = %Type.Any{}

      assert Default.validate(type, "id", %{}) == {:ok, %{}}
    end
  end
end
