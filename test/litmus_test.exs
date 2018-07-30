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
          min_length: 3,
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^[a-zA-Z0-9_]*$/,
            error_message: "username must be alphanumeric"
          },
          trim: true
        },
        "password" => %Litmus.Type.String{
          length: 4,
          required: true,
          trim: true
        },
        "dob" => %Litmus.Type.String{}
      }

      req_params = %{
        "id" => "abc",
        "password" => " 1234 ",
        "user" => "qwerty"
      }

      modified_params = Map.replace!(req_params, "password", String.trim(req_params["password"]))

      assert Litmus.validate(req_params, login_schema) == {:ok, modified_params}
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
