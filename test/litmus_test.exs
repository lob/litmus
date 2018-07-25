defmodule LitmusTest do
  use ExUnit.Case
  doctest Litmus

  alias Litmus.Type

  describe "validate/2" do
    test "validates data according to a schema" do
      login_schema = %{
        "id" => %Litmus.Type.Any{
          required: true
        },
        "user" => %Litmus.Type.String{
          max_length: 6,
          min_length: 3
        },
        "password" => %Litmus.Type.String{
          length: 4,
          required: true
        }
      }

      req_params = %{
        "id" => "abc",
        "password" => "1234",
        "user" => "qwerty"
      }

      assert Litmus.validate(req_params, login_schema) == {:ok, req_params}
    end

    test "errors when a disallowed parameter is passed" do
      login_schema = %{
        "id" => %Type.Any{
          required: true
        }
      }

      req_params = %{
        "id" => "1",
        "abc" => true
      }

      assert Litmus.validate(req_params, login_schema) == {:error, "abc is not allowed"}
    end
  end
end
